% Porting a Game to MUGS

**WIP as of 2021-05-11**


Already have a game implemented that you'd like to port to MUGS?  Great!  This
guide should help you get started.


# Step 0: TEST YOUR MUGS INSTALL!

If you haven't already done so, follow the [MUGS Install Guide](install-mugs.md)
to get MUGS installed properly, test that you can play a couple simple text
games, create a persistent identity universe, start a WebSocket server, connect
to it, and create identities.

If you haven't done these steps first, the following sections will likely be
quite confusing, and you may find yourself very frustrated if it turns out MUGS
isn't working correctly on your system.


# Step 1: Refactoring

Before doing the actual MUGS port, it's useful to begin with some initial
refactoring within your already-working game.  This will reduce the porting
difficulty, while allowing you to continuously test the working game to make
sure nothing gets lost in the refactoring work.


## Architecture

The biggest change that MUGS will impose isn't actually particular to its APIs,
but rather to its basic architecture.  Most "personal project" games are
designed for a single player, or perhaps a couple players sharing a single
computer.  This often results in code that mixes different responsibilities, or
makes simplifying assumptions based on synchronous local play, simply because
there was no strong reason *not* to.  For example, an adventure game might only
simulate the creatures currently visible to the player instead of across the
whole game map; an action game might detect collisions not by intersecting
bounding hulls but by checking whether sprites overlap on the screen at
rendering time; a game UI might assume that it has total knowledge of the
entire game state at all times and that state changes are strictly ordered.

In contrast, MUGS is thoroughly client/server and asynchronous, strictly
separating server-managed game state from the view of any individual player.
The server is the ultimate arbiter of "what really happened" when clients
disagree due to (for example) network lag.  In games that don't feature
[perfect information](https://en.wikipedia.org/wiki/Perfect_information), the
server is responsible for filtering game updates for each participant.
Similarly, MUGS separates the game *client* and game *UI*.  A game *client*
packages requests and messages to be sent to the server, validates responses
and push updates from the server, and tracks locally-cached data.  A game *UI*
handles user input and renders an individual's view; it's strictly a player I/O
function.


## Separating Tiers

This server/client/UI separation is your first refactoring hurdle.  If you have
a modular or object-oriented design already, you should separate at least the
following functionality:

"Server"
: Global game state, hidden information, semantics, and game rules

"Client"
: Communication and caching between UI and Server; UI and Server code should
  *never* directly call each other

"UI"
: App front-end, user input, audio, and graphics

Make sure that proper abstractions are maintained between each layer, and
none of them try to directly modify each other's internal data structures.


## Embracing Asynchrony

Break any assumptions the game code is making that requests/responses are
immediate and act like function calls.  While the UI and client reside in the
same process and can communicate efficiently, the client and server will in
general be on opposite ends of a (possibly very slow) network connection.  User
actions aren't immediate or guaranteed to succeed; they must be converted to
request messages and sent to the server to be arbitrated.  *If* the server
responds, it may indicate the action doesn't make sense, that it isn't that
player's turn, that other participants have already left the game, or any
number of other failure modes.

One way to do this while refactoring your existing game code is to have the
client module always return a Promise for any request from the UI, kept or
broken depending on the server's response.  Asynchronous push messages from the
server can be simulated by sending them through a Channel.


## Time is Relative

Game time should be completely separated from wall clock time, and the server
alone controls its flow.  Note that variable network lag and clock skew ensure
that the client cannot even assume a stable offset between local time and
server time, and almost certainly multiple participants in the same game will
see quite different clock disparities at any given moment.

Most importantly, the game world update rate should be completely independent
of the UI's display frame rate.  Especially in action games, it is easily
possible for the server to send multiple updates while the UI renders a single
very heavy frame, or for a fast UI to render several predicted frames to smooth
the player's experience while waiting for a canonical update from the server.


## Testability and Debuggability

At the very least, you will need to be able to test that your server and client
modules are working correctly (and debug them if they aren't), *completely
independently of the UI.* In other words, you should be able to
programmatically drive your client and server modules, and see that all the
expected semantics are properly handled, without needing to use the player UI
module at all.


# Step 2: Stub Your Game in MUGS

While MUGS tries to reduce pointless boilerplate (or at least, amortize it
across many games whenever possible), there is a minimum set of basics that
you'll need to stub out before MUGS will recognize your game plugins and offer
your games from the server and in the various UIs.


**WIP: MORE TO COME**
