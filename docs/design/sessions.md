% Sessions and Identities

*Reviewed 2021-03-03 by japhb*


**NOTE: This was an early aspirational design rumination; it is more or less
        in the right direction, but only partially implemented at this time.**


Need common concepts of session, game, player, etc. that will work across all
types of clients and game types.


UI paradigms:

* Plain (or at most ANSI colored) text
* Full-terminal UI
* Web UI
* Desktop GUI
* Small device app
* Console game


Game types:

* Board games
* Card games
* Interactive fiction
* Roguelike
* CRPG
* MUD
* RTS
* MMORPG


Axes of difference:

* Single v. multi-player
* Turn-based v. real-time
* Abstract v. geometric topology
* Privileged admins/GMs v. "host" v. pure peer
* All participants known v. possible strangers
* Saveable v. always on v. join/quit at defined moments v. always start at beginning
* Fully cooperative v. squads/teams v. fully competitive
* Player controls one unit/character v. many
* Moving v. territory building
* Exploration v. known map
* Random v. fixed map


Proposed sequence:

#. Player starts client, optionally specifying game, server, save ID, etc.
#. If game is to run locally or player wishes to host, start game server,
   retaining admin credentials
#. Client connects to game server and authenticates the player's user account to
   start a play session
#. Player chooses a persona/character to play as, if they have more than one on
   this server
#. Client requests server to switch session to chosen persona/character
#. Client requests new game, enter existing live game, load game from save data,
   or wait for game to start
#. Server creates game and joins character to it, joins character to existing
   game, loads saved game and joins character (possibly only if save already
   includes them), adds character to lobby for game, or denies request
#. If user is already admin, or authenticates as such, server grants special
   powers, including load/save/end/restart/kick/grant/etc.
   * Note: may want to make admin powers short-lived as with sudo, for similar
     reasons
#. When session disconnects, if local game or player hosting and wishes to end
   game, exit game server; otherwise remove or freeze character's avatar(s) as
   appropriate


Miscellaneous thoughts:

* Different game types will use different protocols to communicate with servers
  * Are there any common subsets that will allow a small number of flexible
    generic protocol drivers to connect to several different games/game types?
* Client should assist user, but user inputs (even those processed by client)
  should never be trusted by server
* For Web UI, server can actually supply client code directly for optimal
  experience; likewise, device and console apps can ensure user has latest UI
  * Every other UI will likely need to assume client code may not match the
    server code version
  * ... and even if the server provided the supposed client code, the server
    should *still* not trust its inputs


Uniqueness and identity:

Account
  : The unit of management for a group of related users, players, personas, and
    characters, possibly sharing rewards/unlocks/etc. and likely defaulting to
    additional system trust between them

User
  : The moniker for a unique set of login or other security credentials

Player
  : A single human (or bot instance) in reality

Persona
  : One of possibly several distinct handles/pseudonyms used by a player (or
    shared by a group, for e.g. a "help desk" persona), which may not have any
    visible connection to the player's other Personas.

Character
  : A single playable entity in a game.  Games may optionally allow players to
    see the persona that is "driving" each character (or perhaps just that two
    different characters have the same persona without revealing that persona),
    but *must not* ever reveal the underlying player to non-superusers.

Character Instance
  : Characters may be instanced into multiple games, and game instances should
    communicate with individual character instances, not the shared character
    definition.  In addition, game-specific additions to the base character
    concept should attach to each individual character instance.

Avatar
  : A sensory or textual representation of a persona or character which may
    vary depending on the capabilities of the player's active UI, from a simple
    name to a full 3D model.
