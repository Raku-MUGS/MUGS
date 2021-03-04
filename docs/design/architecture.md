% Architecture Sketch

*Reviewed 2021-03-03 by japhb*

NOTE: SPOT and Queryable are NYI (Not Yet Implemented).  At this time server
components can still directly talk to Storage drivers.

```
UI ↔ Client::Game ↔ Client::Session ⇄ Server::Session ↔ Server::Game → SPOT → Storage
                                                                    ↖    ↓    ↙
                                                                     Queryable

UI:              CLI, TUI, GTK, Qt, WebSimple, WebCanvas, WebGL, etc.
Client::Game:    <Game> is <Genre>
Client::Session: Supplier, WebSocket, etc.
Server::Session: ""
Server::Game:    <Game> is <Genre>
SPOT:            Handles commands and maintains Single Point of Truth
Storage:         Fake in-memory, Red::SQLite, etc.
Queryable:       Data cache optimized for fast queries
```
