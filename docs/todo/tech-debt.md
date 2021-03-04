% Tech Debt TODOs

These todo items collect known tech debt waiting to be repaid.

* AUTOMATED TEST ALL THE THINGS
  * Test that all storage backends are equivalent
  * xt tests for code standards:
    * Avoided terms in repo
    * XXXX, TODO, WIP, NYI, and similar comments
    * WHY info available everywhere
    * No string die calls or AdHoc exceptions
  * Unfinished test files
    * 03-file.t: write-yaml-file
  * Missing test files
    * Remaining MUGS::Util:: tests
    * Remaining MUGS-Core roles
    * Storage drivers
    * Remainder of MUGS-Core
    * Genre client/server pairs
    * Game client/server pairs
    * Just ... a lot of them, really
* WHY ALL THE THINGS
  * Make sure all classes, roles, enums, methods, subs, etc. have WHY info
* Convert dies and AdHoc throws to custom exception classes
  * Document exception rules: X::MUGS, required attributes, thin factoring, etc.
  * Check that all exception classes inherit from X::MUGS
  * While building out system, may allow AdHoc in Game/Genre directories
  * UIs should have safe handling of die/throw (possibly based on debug setting)
  * Default exception messages should not include user-controlled content
* Type tightening
* Extract MAIN multis out to individual game UI modules
* Poor performance when using JSON-over-WebSocket
  * After [initial optimizations](https://github.com/croservices/cro-websocket/pull/28),
    majority of latency is caused by the interaction of TCP Nagle and Delayed ACK
    (~85ms out of 100-110ms RTT); waiting on https://github.com/MoarVM/MoarVM/issues/1229
    to turn on TCP_NODELAY on both ends
* Address XXXX, TODO, WIP, NYI, etc. comments throughout code
* Handle exceptions everywhere without crashing
* Extract message data using MUGS::Message.validated-data everywhere; no
  direct MUGS::Message.data access on read path
* Switch GameID over to an opaque hard-to-guess ID
* General security and error robustness
  * Separate message and non-message exception classes
