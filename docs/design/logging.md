% Event Logging


# Log Goals

* Performance info
* Anti-abuse
* Load estimation
* Game popularity
* Debugging
* Record for replay?


# Log Non-Goals

TO BE AVOIDED:

* Capturing credentials
* Capturing PII
  * What identities are considered PII?
  * Need separate very short-lifetime log for anti-abuse with extra info?


# Configurability

* Log verbosity (based on event rarity, probably)
* Separate logs for different privacy levels?
* Separate logs for each game individually, and for out-of-game in general?
* Compression
* Encryption


# Performance Requirements

* Rare events: >10ms, if non-blocking for concurrent tasks
  * Server startup/shutdown
  * Game plugins loaded
  * Game create/pause/restart/quit
  * Identity creation/modification
* Uncommon events: >1ms if non-blocking other participants, 1ms at most if blocking
  * Connection attempted/dropped
  * Login attempt/success/failure
  * Game join/leave
  * Winloss and Gamestate changes
* Common events: 10-100µs to keep from dominating performance
  * Game action
  * Game event
  * P2P message
  * Game state computation
  * Game update messages
  * Exception captured
* Very common events: AFAP
  * Message serialization
  * Message transmission
  * Message deserialization
  * Message validation
  * Message queuing
  * Update rendering


# Notes

* GameEvents and game-wide updates already get pushed to all clients; they must
  be considered recorded out of server's control already.
* Common path should have everything needed, but NOT bloated
  * And it should be easy (and efficient) to turn off unneeded features
