% Error-Handling Principles

*Reviewed 2021-03-03 by japhb*

**NOTE: ASPIRATIONAL; ONLY WIP IN THIS RELEASE**


* All Server components (including game engines) throw exceptions for abnormal
  conditions/behaviors:
  * Syntactically, structurally, or semantically invalid client requests
  * Server or game logic internal errors
  * Server or game in invalid state
  * Backend failure
* Exceptions are logged and one of:
  * Shutdown server (corrupted global state or otherwise unsafe to continue)
  * Stop game (corrupted game state)
  * Immediately close client session(s) (possible abuse/security issue)
  * Retried with backoff until success or timeout (transient failures)
  * Coerced to error codes to transmit to client (less critical exceptions)
* Server and game engines return standard error codes for normal events that
  happen to be unavailable or incorrect; examples:
  * Can't do that right now
  * Out of required in-game resource
  * NPC does not agree (e.g. trying to sell an item)
  * Target of action or message has left the game
* Client and utility components throw exceptions for abnormal conditions:
  * Server message unparseable
  * Config file corrupt
  * Server connection broken without normal session shutdown
* Server error codes and client exceptions are converted to user-visible errors
  only in UI layer (app-wide or in-game)
* Error messages are localized to player's preferred language whenever possible
