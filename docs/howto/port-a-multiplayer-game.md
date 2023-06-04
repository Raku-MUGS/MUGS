% Porting a Multiplayer Game to MUGS

**STUB ONLY**


Want to port a multiplayer game to MUGS?  Great!  That's exactly what MUGS was
designed to do best, and this guide will help you get started.

Note that we'll be diving into the deep end right off, considering just the
parts of multiplayer gaming that are different from solo games (a much simpler
case).  If you haven't already read
[Porting a Solo Game to MUGS](porting-a-solo-game.md),
please do so now.


# Differences From Solo Games

In multiplayer games, the server is the ultimate arbiter of "what really
happened" when clients disagree due to (for example) network lag.  In
multiplayer games that don't feature
[perfect information](https://en.wikipedia.org/wiki/Perfect_information),
the server is also responsible for filtering game updates for each
participant.
