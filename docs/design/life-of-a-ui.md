% Life of a UI


**NOTE: KNOWN TO BE OUT OF DATE.  This doc has not been updated for 0.1.2!**


So much of the client UI logic is distributed amongst layers of abstraction and
inheritance that it's not obvious what actually happens when a user starts
their client program and plays a game.  Obviously this will vary considerably
depending on whether they are playing a purely local UI (such as terminal or
GTK+ app) or a remotely-proxied UI (such as UIs served via web browser).


# Local UIs

Local apps are the simpler case, since they run locally and directly connect to
the MUGS server (whether process-internal or remotely hosted), without a UI
conversion proxy in the middle as would be required for a web UI.  Here's a
simple outline of the process:

  * `mugs-<ui>` script
    * `MUGS::App::<UI>::MAIN` subs
      * `MUGS::App::LocalUI::play-via-local-ui`
        * `$app-ui = MUGS::App::<UI>.new` (subclass of `MUGS::App::LocalUI`)
        * `$app-ui.initialize`
          * `$app-ui.gather-os-info`
          * `$app-ui.load-configs-or-exit`
          * Initialize UI toolkit (e.g. GTK+)
        * `$app-ui.ensure-authenticated-session`
          * `$app-ui.decode-server`
          * `$app-ui.connect`
            * `MUGS::Server::Stub::create-stub-mugs-server` (for in-process servers)
            * `MUGS::Client::Session.connect`
          * `$session.authenticate`
            * Loop until user provides correct credentials and login succeeds
        * `$app-ui.new-game-client`
          * `$!session.new-game` (unless reconnecting to an existing game)
          * `$!session.join-game`
        * `$app-ui.launch-game-ui`
          * `MUGS::UI.ui-class` (look up by ui-type and game-type)
          * `$game-ui = $app-ui-class.new`
          * `$game-ui.initialize`
          * `$game-ui.show-initial-state`
        * `$app-ui.play-current-game`
          * App and game UIs have control until all games end or player leaves
        * `$app-ui.shutdown`
          * `$!session.disconnect`
          * Shutdown UI toolkit (e.g. exit GTK+ windows)


## Local UI Startup

Each UI starts with the user running a trivial script that simply loads the
appropriate `MUGS::App` class and lets it take over control.  Here's the entire
script for the CLI UI, `mugs-cli` (all the others are near-identical, save for
the referenced class):

```
#!/usr/bin/env raku
use v6.d;
use MUGS::App::CLI;
```

Actual execution begins with the `multi MAIN` subs at the end of
`MUGS::App::CLI`.  Each of these corresponds to a single known game for that UI
which knows what game-specific command-line options are available.  There are
also common options defined by `$common-args` and documented in `GENERATE-USAGE`
that apply to all games.  If the user does not specify a particular game, and
the UI supports it, the default will be the game-selection lobby for that UI.
Aside from some testing-specific "games", each of these `multi MAIN` variants
then hands off to `play-via-local-ui`, defined in the base `MUGS::App::LocalUI`
module.

`play-via-local-ui` constructs the outer app-level UI object (a UI-specific
subclass of `MUGS::App::LocalUI`) and calls `$app-ui.initialize` on it, which is
responsible for core startup functions: gathering basic OS info such as OS
family and user language preferences, loading config files, initializing the
appropriate UI toolkit if any, and so on.  Since the client can't safely
continue if these fail, exceptions in this phase will cause the UI object to
report errors and exit immediately.

With the app UI minimally started, `play-via-local-ui` attempts to connect and
login to the requested MUGS server using `$app-ui.ensure-authenticated-session`,
which starts by calling `$app-ui.decode-server` to canonicalize the server URL.
It then calls `$app-ui.connect` with the decoded result to either connect to a
process-internal stub MUGS server or to an actual remote MUGS server if the user
specified one.  If a process-internal server is needed, it is created using
`MUGS::Server::Stub::create-stub-mugs-server` and the connection type is set to
use an in-memory Supplier-based method; if the server is remote, the connection
type is set to use an encrypted Internet transport (WebSocket in the current
version).  `MUGS::Client::Session.connect` is then called to actually connect
and initialize the session (over which all per-game communication will be
multiplexed).

Finally `$app-ui.ensure-authenticated-session` attempts to actually log in to
the server via `$session.authenticate` using the user's configured default
credentials.  If these don't work, the app UI queries the user in UI-appropriate
fashion for correct credentials, looping after each failure until either success
or the user exits.

As with `$app-ui.initialize`, `$app-ui.ensure-authenticated-session` will exit
the program completely on session setup failure as the client program cannot
continue without a valid active session.


## Local Game UIs

Once the local UI is started and has an active authenticated session with the
server, `play-via-local-ui` is ready to start the actual game-specific UI.

This starts with calling `$app-ui.new-game-client` to create an instance of a
game-type-specific (but *not* UI-specific) client object to manage that game's
client-side logic and communications with its server-side counterpart.  Unless
the user provided an existing `GameID` to reconnect to,
`$app-ui.new-game-client` first calls `$!session.new-game` to request the server
create a new game of the requested game type using the user's requested game
config settings if any; this returns the `GameID` of the newly created game.

`GameID` now in hand, `$app-ui.new-game-client` then calls `$!session.join-game`
to actually join the game using the player's current default `Character`,
finally returning a fully instantiated game client object.

`$app-ui.launch-game-ui` then takes over, first determining the right game UI
class for the chosen ui-type and game-type using `MUGS::UI.ui-class` and
instantiating it, passing the game client object from `$!session.join-game` and
the top-level app-ui object itself, in case the game UI needs to make requests
of the application frame.  The game UI object is then started up using
`$game-ui.initialize` followed by `$game-ui.show-initial-state`.

With the user's originally requested game now created and joined, and its game
UI started, `play-via-local-ui` can finally hand off control to the UI itself
via `$app-ui.play-current-game`, which allows the player to interact with active
game UIs, creating new ones as requested, and cleaning up when each game
finishes.  UIs that can play multiple games at once will switch back and forth
via a series of app UI methods: `launch-game-ui`, `switch-to-game-ui`, and
`leave-current-ui`, plus a few variants for leaving all games at once, switching
back to the single common game selection lobby UI, etc.

When the last remaining game UI exits, `$app-ui.play-current-game` returns
control back to `play-via-local-ui`, which does final cleanup by calling
`$app-ui.shutdown`, which disconnects the session, shuts down the base UI
toolkit, and finally cleanly exits the program.
