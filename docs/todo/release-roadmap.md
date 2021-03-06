% FLOSS Release Roadmap

*Reviewed 2021-04-15 by japhb*


This doc puts forward a roadmap for major FLOSS releases leading up to an
eventual MUGS 1.0 release.  Pre-public versions were all early 0.0.x; MUGS was
initially announced publicly at 0.0.5.  The first public roadmapped release was
0.1.0, the "Proof of Concept" release.  Work on 0.2.0 is well under way, and
further roadmapped releases will follow when their respective key deliverables
are completed.


# 0.1 Proof of Concept *([released](../announce/v0.1.0.md) 2021-03-21)*

There are a great many TODO tasks already identified for MUGS, but a smaller
number needed before the initial proof-of-concept FLOSS release.  Most of
these are just getting things cleaned up enough that people can reasonably
try it out and give feedback other than "It's completely broken for me."

This list is **COMPLETE!**

* ✓ Core functionality
  * ✓ Content tags
  * ✓ Genre tags
  * ✓ Game descriptions
  * ✓ Hooks for start-game and stop-game
  * ✓ Start or stop game depending on participant count
* ✓ Docs
  * ✓ READMEs rewritten (or pointing to a Getting Started doc)
  * ✓ Simple contributing instructions written
  * ✓ Code style documented in coding-standards doc
  * ✓ All TODO docs cleaned up
  * ✓ Draft release guide
  * ✓ All design docs marked with implementation status (unless complete)
  * ✓ All docs marked with latest review date
  * ✓ Add Changes files for all repos
* ✓ Games
  * ✓ Guessing
    * ✓ Snowman supported as default word-guessing game
    * ✓ Multi-round Snowman
* ✓ Organizational
  * ✓ Create Raku-MUGS GitHub org
  * ✓ Create 'mugs' ~~Freenode~~ group and #mugs IRC channel (UPDATE: MOVED TO Libera.Chat !)
* ✓ Packaging
  * ✓ File extensions changed to current Raku standards
  * ✓ Support for plugging UIs and games
  * ✓ Meta files checked and updated
  * ✓ MUGS-Core separated from MUGS-Games and MUGS-UI-*'s
  * ✓ `cro run` support restored
  * ✓ Docker support restored
  * ✓ Automate easiest parts of release process
* ✓ Testing
  * ✓ All README info tested on fresh install
  * ✓ MUGS::Util::* fully tested
* ✓ UIs
  * ✓ All games exist in at least 2 UIs
  * ✓ CLI and WebSimple UIs approximately equivalent
  * ✓ Turn-based games tested with a screen reader
    * ✓ in CLI
    * ✓ in web browser
* ✓ UX
  * ✓ Game selection interfaces show genre tags and description


# 0.2 Prototype *(Current WIP)*

The first major release after the Proof of Concept will need to support a much
wider set of games and enough functionality to prove the value proposition.

This list is about **60%** solid:

* Cleanups
  * `git grep 'XXXX\|WIP\|NYI\|TODO'` in each repo
    * Simple items addressed
    * Larger items filed as TODOs
* … Core functionality
  * ✓ DB schema management
    * ✓ Track schema version and state in `mugs_schema_state` table
    * ✓ Support schema update in `mugs-admin`
    * ✓ Draft of schema bootstrap, repair, and update in storage driver
  * ✓ Draft of deconfused identity names
    * ✓ All identities in a universe share the same (deconfused) namespace
    * ✓ Names folded by spacing, case, marks, and compatibility
    * ✓ Names limited to PRECIS-compatible codepoints and 63 characters max
  * … Support for more multiplayer game play
    * ✓ `GameEvent`s and `game-update`s pushed to game participants
    * ✓ Game startup push messages tracked and handled
    * ✓ Allow override of game start and stop conditions
    * … Support both PvP and co-op play, and per-participant `winloss` status
  * Achievements/Awards/Accomplishments
  * Game config menus
  * Teams
  * Invites
    * create account
    * join game
    * join team
  * Messaging
    * "nearby" messaging (e.g. say/shout in map-based games)
    * team messaging
    * persona messaging
    * offline messaging
    * server notices
* … Docs
  * … New docs
    * … Game Classes
    * Life of a Request
    * Life of a UI
    * Message Flow diagram
    * Game class method override diagram(s?)
  * … Release guide tested and tuned
  * Review pass
* … Error handling
  * ✓ Include client username in server connection debug info
  * ✓ Refactor/unify behavior of turn validation, submission, and error handling
  * … Error testing "game"
  * All bare die converted to X::MUGS::Request::AdHoc or other appropriate X::MUGS
  * All ad hoc exceptions converted to proper X::MUGS subtypes
  * Sad paths explored
  * Client and Server independent of each other's failures
  * Separate error messages for debug logs and user-visible messages
* … Games
  * Action
    * Arcade2D
      * Two multi-player 2D arcade games
  * … TurnBased
    * … BoardGame
      * … RectangularBoard
        * ✓ MNKGame
          * ✓ TicTacToe
        * … Checkerboard
          * Draughts
            * EnglishDraughts (AKA American Checkers)
    * … CardGame
      * … Standard52CardDeck
        * A shedding-type game
        * Poker of some form
    * Guessing
      * FourDigits
    * Interactive Fiction
      * At least one basic IF playable
  * Social
    * Chat Room
* Packaging
  * Docker packages uploaded to GitHub org
  * Automate more (all?) of release process
* Reliability
  * Limit max active games
  * Server load shedding
  * Client able to forget old requests with no response (or whose game is gone)
  * Protocol details: protocol version, sequence numbers, security, etc.
* Testing
  * Core roles fully tested
* … UIs
  * … CLI improvements
    * ✓ Show active game list and allow joining games started by other players
    * ✓ Simplify `MAIN` and allow users to specify arbitrary game-type
    * ✓ Handle expanded server push and game event semantics
    * … Support more Readline-style bindings in input module
    * … Cleanups and refactoring
  * … At least one new UI added
    * … TUI
    * GTK?
    * Pop?
  * Added UI(s) support login and game choice
  * All games tested on at least one UI working with multiple assistive technologies
* … UX
  * … List of active games shows which are available to join


# 0.3 Alpha 1

With the basic value proposition shown in the prototype, the first alpha pivots
to tackling internationalization and manageability, along with more depth in
each of the major work themes.

This list is about **40%** solid:

* Cleanups
  * XXXX review pass
* Core functionality
  * DB management
    * Improved schema bootstrap, repair, and update
    * Data migration management
    * Data backup/restore
  * Names Unicode confusable-folded
  * Challenge level
    * Skill ratings
    * Skill matching?
  * Bots
    * Server-side
    * Client-side
    * Gateway
    * Bot invites
    * Bot autofill
* Docs
  * Review pass
* Error handling
  * Testability
    * Fault injection
    * Latency injection
* Games
  * Arcade
    * Side-scroller shmup
    * Side-scroller platformer
  * BoardGame
    * Checkerboard
      * Chess
    * Goban
      * Go
    * MNKGame
      * Gomoku
  * CardGame
    * Klondike Solitaire
  * Roguelike or CRPG
* I18N
  * Basic multi-language support (LTR-only in this release)
  * Various testing "translations" such as double-wide
* Manageability
  * Logging much more complete
  * Monitoring support
* Testing
  * Storage drivers fully tested
* UIs
  * Review AT support for all games


# 0.4 Alpha 2

The second alpha follows the first with easier onramps for users and developers.

This list is about **20%** solid:

* Cleanups
  * XXXX review pass
* Docs
  * Comprehensive Getting Started
  * Review pass
* Games
  * MUD/MUSH
* I18N
  * Deeper locale support
  * RTL support, with "180 degree rotated" testing "translation"
  * Hooks for using a translation service for messages
* Manageability
  * Fleet management
  * Universe management
* Testing
  * Entire MUGS-Core fully tested
* UIs
  * Review AT support for all games


# 0.5 Alpha 3

At this point the following is more aspirational and directional than solid:

* Cleanups
  * XXXX review pass
* Docs
  * Review pass
* I18N and L10N
  * Getting Started translated into multiple languages
  * All UI and error messages translated into multiple languages
* Manageability
  * Schema rollouts
  * Server rollouts
* Testing
  * Client/Server pairs for each genre fully tested
* UIs
  * Review AT support for all games


# 0.6 Alpha 4

* Cleanups
  * XXXX review pass
* Docs
  * Review pass
* Testing
  * Client/Server pairs for every game fully tested
* UIs
  * Review AT support for all games


# ???

* IRC gateway?
