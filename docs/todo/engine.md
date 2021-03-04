% Engine TODOs

*Reviewed 2021-03-03 by japhb*


These todo items are for the core engine itself -- pretty much all of the code
that is not specific to a particular UI type, game type, or game.

* WIP: Permanent storage
* WIP: Server-generated config options
* WIP: Async and out-of-order responses
  * Stronger validity checking on message exchanges and reply pairing
  * Injectible errors and latency
    * Note: may be able to do this by layering session Supplies
* Time
  * Time limits: game, character, turn, etc.
  * Pausable internal game clock
    * Support for "chess pause": current player puts move in escrow
    * Generalize to games in which participants simultaneous plan their move
      then all reveal their play at once
* Multiple players
  * User count limits, per game and per server
  * Min players, start players, max players, joinable, invitable
  * Game doesn't start until minimum number of players have joined
  * Character removal
    * Removing from turn order
    * What happens when mid-hand/round?
    * Abandon game when last person leaves
    * Handling player forfeit
  * Update participants when action completes
    * All participants immediately for perfect information, turn-based games
    * Nearby participants at next tick for action-based, limited knowledge games
  * Should be possible for a single *player* to be connected as multiple
    characters/avatars in the same game (and also for game admins to disallow
    this when they want player/character identity to hold)
    * Should this be by *persona* instead of by *player*?
      * Pro: Prevents info leakage of the personas owned by a player
      * Con: Allows a player to easily create many sock puppets (without at
        least having to create separate users/accounts for them)
* Sessions and connections
  * Persistent sessions and reconnection
  * Frontend --> backend connection multiplexing
  * Max connections/sessions
  * Load shedding
* General invite tokens
  * Fixed lifetime, single use
  * Invite to join: server, account?, team, game
  * Invite to be marked as "friends"?
  * 2FA for tokens?  (e.g. the token code + an SMS code)
* Spectators
  * Separate spectator game(s) for a given real game to scale crowds?
  * Separate control of invites for players, spectator games, and plain spectators
* Game result tracking
  * High scores
  * Accomplishments/Achievements/Awards/Rewards
  * Player rankings
  * Tournament tracking
* Messaging
  * Persona messaging
  * Offline messaging
  * Server notices
* Service instance federation?
* Service management
  * logging
  * monitoring
  * slow rollouts
  * rollbacks
  * live backups
  * fleet management
  * universe management
  * etc.
* Repeatable playbacks
* Authn/login provides medium-life token that survives FE server failure
