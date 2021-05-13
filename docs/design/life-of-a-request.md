% Life of a Request


**NOTE: KNOWN TO BE OUT OF DATE.  This doc has not been updated for 0.1.2!**


# All Requests

Initial checks apply for any incoming message, regardless of in-game status:

* Packet received from comm channel
  * Throws exception for unparseable WebSocket Frame
* `Str.decode('utf-8')`
  * Throws adhoc exception on malformed UTF-8
* `from-json` decode
  * Throws adhoc exception for failed JSON parse
* Check if `$struct<game-id>` exists to determine if in game
  * Silently chooses generic request path if `$struct` is not Associative
    (safe because from-struct will first check type of `$struct` anyway)
* `MUGS::Message::Request{,::InGame}.from-struct`
  * Returns Nil unless outer layer structure and types pass simple checks
  * `$struct<data>` only needs to be a Map:D, no internals are checked
* Dispatch to `MUGS::Server::Session.handle-client-message` multi
  * Returns RequestError immediately for Nil case

XXXX: How are exceptions at these early stages caught and handled?


# Out-of-Game Requests

Always:

* Use general request multi of `handle-client-message`
  * **Exceptions beyond this point are caught and converted to error responses**
* Send auth-error unless user has already authenticated or is trying to

By request type:

## authenticate

* **Exceptions caught for this request type are converted to auth-error**
* `validated-data` checks for presence/type of username and method fields
  * Throw exception (which will convert to auth-error) if field missing or wrong type
* Send auth-error if unknown auth method
* Check for presence of password field (type checked by validated-data, if present)
  * Send auth-error if password missing
* Call `$!server.authenticate-user`
  * Get credentials-for-username; return Empty if none (which will fail verification)
  * Check for credentials that verify
    * If found, log UserAuthSuccess, and set `$session.user`
    * Otherwise, log UserAuthFailure and throw InvalidCredentials exception
      (which will convert to auth-error)
* Send auth-error unless user object defined and correct type
* Send Success

## get-info-bundle

* `validated-data` checks for presence/type of info-types field
* Convert words from info-types to Set
* Call `$!server.get-info-bundle`
  * Call get-info-<type> for all recognized info-types in set
    * For available-identities:
      * Call `user.available-personas`
        * May be empty
      * Call `persona.characters` for each persona
        * Call `character.screen-name` for each character in persona
          * Always defined but might be empty
      * Call `persona.screen-name` for each persona
        * Always defined but might be empty
* Send success with requested info

## new-game

* `validated-data` checks for presence/type of game-type and config fields
* Call `$!server.new-game`
  * Throw exception unless game-type has registered implementation
  * Attempt to instantiate implementation class
    * Basic checks of type of particular config fields (ignores all others)
    * Throws exception if those config fields exist but have wrong type
  * Log GameCreated
* Send Success
  * XXXX: include full game config?

## join-game

* `validated-data` checks for presence/type of game-type, game-id, and
  character-name fields
* Call `$!server.join-game`
  * Throw exception unless game-id exists, game-type has valid implementation,
    and game-id has matching game-type
  * Find character by name
    * Throws InvalidEntity exception if not found
  * Add character to game
    * XXXX: No permissions checks here
    * Throw CharacterAlreadyInGame if so
    * Call `wrap-character` to create in-game instance of character
      * XXXX: Game-dependent code
  * Log GameJoined
  * Determine initial game state for this character
    * XXXX: Game-specific code
* Send Success with initial game state

## Unknown request type

* Send RequestError


# In-Game Requests

* Use InGame request multi of `handle-client-message`
  * **Exceptions beyond this point are caught and converted to error responses**
