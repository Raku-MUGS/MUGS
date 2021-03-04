% Concurrency

*Reviewed 2021-03-03 by japhb*


By its very nature, MUGS must be highly concurrent.  A single server may be
handling dozens or even hundreds of games, each with many participants each
in several games at once, and there may be thousands of connected sessions.
Alternately, there may be fewer connected sessions, but with each of them
playing very intense twitch games, for a similar total level of concurrency
but with a very different "shape".

Worse, there is no guarantee that all participants are benign; on the open
Internet, it is highly likely that at some point malicious players will
sign up (or even that malicious or cheating servers appear).  Concurrency
handling is an obvious target for someone wishing to DoS the other
participants.


# Problems

High concurrency immediately presents three major problems:

* It's hard to reason about and code correctly.
* It quickly exposes any latent threading hazards.
* It is very difficult to scale without biasing towards a single use case.

To manage the first two problems, MUGS eschews low-level concurrency primitives
wherever possible in favor of the higher-level tools available in Raku, such as
Supplies and Channels for event delivery and queuing.  Similarly, rather than
hand-coded event loops, MUGS uses the Raku-native concurrency-managing `react`
construction.  When there is a choice for slightly higher efficiency or
likelihood of correct implementation, the latter is nearly always the right
choice.

The last "problem" is actually an entire family of problems, and the desire to
support many concurrent use cases while serving possibly-malicious players
unfolds into a set of design constraints.


# Constraints

MUGS attempts to use execution resources efficiently, without allowing abusive
users to ruin everyone else's experience.  In fact, the design must balance
several key goals:

* Resource hogs only hurt themselves
* Other types of abusers are easy to isolate and contain
* Games are isolated from each other as much as possible
* The service remains smooth and responsive for everyone (on a human scale)
* Overall concurrency scaling is maximized


# Threads and Tasks

While Raku's scheduler is fully pluggable, Rakudo's default is a green-thread
task scheduler which tries to fully utilize a smaller number of OS threads by
sharing them across the offered workload.  Each execution unit is a "task", and
thus it makes more sense to talk about how MUGS apportions work across tasks.

The client side is relatively simple, with only 3 main tasks:

* A task for the session's network listener/dispatcher
* A task for the UI (for UI toolkits that require a dedicated UI thread)
* A task handling everything else

Each server-bound request also creates a Promise that will be kept or broken
when the server responds to that request.  *(NYI: Removing old Promises left
by an unresponsive or misbehaving server)*

The server is more complex:

* A task watching for shutdown signals
* A task watching for new network connections
* A task handling out-of-game requests *(NYI, currently using session tasks)*
* One task for every active game
* One task for every active client connection (server session)

Thus the server has `(3 + num-games + num-sessions)` tasks, multiplexed across
the OS threads provided by Rakudo's scheduler.


# Supplies and Channels

In order for all these cooperating tasks to communicate, especially since each
session may need to talk to many games and vice-versa, MUGS uses thread-safe
Raku constructs for internal messaging.

Cro, used for HTTP and WebSocket traffic, is heavily Supply-based; on both
ends of the connection, the body of the Cro-native messages are converted to
MUGS::Message objects, while still transiting through Supply chains.  (When
using an internal stub server rather than a network server, this is simulated
by just connecting client and server Supplies together; everything else remains
the same.)

On the client side, received server responses are used to fulfill Promises from
the client's async requests; server push messages are simply dispatched as
appropriate.

On the server side, request messages received from a particular session are
checked for the most basic server-protecting validity (e.g. that the message
cleanly parsed, and that the session is fully logged in if the request is for
anything other than to authorize a login or create a new user).  After those
basic checks, in-game requests are sent to the unique Channel that serves as
the input queue for that game, where they undergo full validation and dispatch.

When a game wishes to send a message to a user (as it will at least for every
incoming request), it sends it to the unique outgoing Channel associated with
each user's Session.

*Out-of-game requests are currently handled differently; they are dispatched
from the user's session directly, rather than via an incoming queue as with
games, though they still send responses via the session's outgoing Channel.
This design is still in flux, and may be replaced by dispatching to one or more
out-of-game request Channels in the same style as for in-game requests.*


# Design Assessment

The current design supports several of the goals/constraints:

* Each server session runs in its own task and self-throttles at the maximum
  load a single session thread can support.
* Each game runs in its own task, taking inputs via Channel and serving
  incoming requests on a FIFO basis.
* Server sessions are isolated from load in each game, at least until total
  server load is too high for busy session and game tasks to each get scheduled
  on their own CPU core.

There are still a few problems though:

* Game input can back up and lag the game; this can occur either because:
  * Input request load is very high and a single thread can't process requests
    fast enough to keep up.
  * There is a high fanout from input requests to output messages (for example,
    if each player action requires updating the visible game state for every
    other player in the game).
* A very noisy game may be able to starve (or at least greatly lag) quieter
  games sharing the same session.
* The client is too trusting that the server will respond to all of its
  requests; outstanding request Promises should time out somehow.
* While structurally resistant to certain types of bottleneck/overload, the
  design hasn't been proved hardened, or tested under very high offered load
  (yet).

Open questions:

* How can MUGS keep a very noisy client from lagging the rest of the game?
  * Can the first lag case be handled by allowing games to spawn subtasks?
  * Can the second lag case be handled by having dedicated fanout tasks whose
    only job is to send game updates to many players at once?
* Would scalability be better or worse if there was a separate output queue
  per game for each session?
* Does Rakudo guarantee that the `whenever` blocks sharing a single `react`
  cannot be starved by heavy load from other `whenever` sources?
  * If not, is there a workaround, or does MUGS need to implement its own fair
    queuing?
