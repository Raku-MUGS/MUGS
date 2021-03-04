% Lifecycles

*Reviewed 2021-03-03 by japhb*

**NOTE: GENERALLY CORRECT, BUT INCOMPLETE**


# Base Lifecycle

Each of the major components (e.g. server, session, client app, game client,
game UI) goes through a standard lifecycle, with minor modifications for each
use component type.  The base lifecycle looks like this:

* Class registration for game-specific components
  * Associates an implementation class with a game-type (and ui-type for UIs)
* Object creation
  * `submethod BUILD` if needed to convert creation args to internal state
    without saving the original args (as for Authentication components), or to
    ensure input validity before building the object (as with server games)
  * `submethod TWEAK` is generally preferred over BUILD for all other
    create-time special needs, such as setting up triggers/callbacks and
    verifying that the new object is in a valid starting state
* `method initialize` called before first use
* *... Normal usage ...*
* `method shutdown` called after last use to shutdown cleanly
* Object destruction
  * `submethod DESTROY` if special care needed for GC-time cleanup

Currently implementation classes are never unregistered.


# UI components

Because UIs have the concept of (de-)activation, such as when the user switches
to a different window, they include additional hooks during normal usage:

* *(Class registration and object creation as usual)*
* `method initialize` called before first use
* *... Normal usage ...*
  * `method activate` called each time UI activated/switched to
  * `method deactivate` called each time UI backgrounded
* `method shutdown` called after last use to shutdown cleanly
* *(Object destruction as usual)*
