% Caches and Invalidation

*Reviewed 2021-03-03 by japhb*

**NOTE: CORRECT, BUT NYI (NOT YET IMPLEMENTED)**


For performance and scalability reasons, some of the storage-authoritative or
transient game data is cached in and served from server memory.  For example,
character objects for all characters that have joined a game are cached in the
`MUGS::Server::Game` object residing in the `MUGS::Server` that is
authoritative for that game.

There are (at least) three cache invalidation problems here:

#. When one session (whether player or admin) changes some global information,
   such as a character's identity details, that information should be quickly
   reflected in all games, sessions, and servers that share the same logical
   namespace/shard (which may be equivalent to sharing backing storage).
#. Some games will be served by multiple servers working together, regardless
   of actual topology.  These servers must all see the same state for shared
   game data, though some games may allow slight time skew before consistency
   guarantees kick in.  (Thus an authoritative leader node or shared storage
   access may be required by some games while others can get by with an
   eventually-consistent network.)
#. Some games will last long enough that their state will need to survive
   server restart or migration even of the authoritative leader node.  For
   these, even game instance-specific data will need to be persist{able,ed} and
   cannot exist *only* within in-memory data structures.
