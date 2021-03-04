% Game Type TODOs

*Reviewed 2021-03-03 by japhb*


These todo items represent the creation or refinement of entire game types,
such as puzzle games or twitch arcade games.

Note: () indicates unimplemented, and may be marked so for an entire genre,
particular games, or selected UIs for otherwise implemented games


* General
  * Genre tags searchable by players
  * Support for skill rating
    * And skill matching?
* Test
  * Simple "games" designed to help test MUGS itself
  * "Games"
    * Echo
      * (Optional transforms: testability and config error handling)
* TurnBased ur-genre
  * Next turn hook, advanced enough to handle games with moving start player,
    changing order, repeated turns, non-integer turn lengths, etc.
  * Additional time limits: per turn and per character
* Guessing -- CLI, WebSimple, (GTK, TUI, WebSPA, WebCanvas)
  * Games
    * NumberGuess -- CLI, WebSimple
    * Snowman -- CLI, WebSimple
    * (FourDigits)
* CardGame
  * Hands/tricks/rounds/games
  * (Subgenres: https://en.wikipedia.org/wiki/Card_game)
    * (Casino)
      * (Poker)
    * (Shedding)
      * (?)
    * (Solitaire)
      * (?)
* BoardGame
  * (Subgenres)
    * (Mancala)
    * (Checkerboard)
      * (Draughts/Checkers)
      * (Chesslike)
  * (Go)
* (Puzzle)
  * Games
    * (?)
* (SimpleArcade)
  * Will need to reduce latency for actions
  * Games
    * ("Snake game" -- GTK, TUI, WebCanvas)
      * (3D first person multiuser snake inside a cube -- WebGL)
    * (Side-scroller schmup -- TUI, WebCanvas)
    * (Side-scroller plaformer -- TUI, WebCanvas)
    * (In general, any 70's/80's-style arcade game, but NOT actual clones)
* IF -- Interactive Fiction
  * WIP: Basic adventure -- CLI, (GTK, TUI, WebSimple)
    * Will need a good natural language parser
  * (MUD -- CLI, TUI, WebSimple)
* (Roguelike)
  * (Single character -- TUI, WebCanvas)
  * (Party RPG -- TUI, WebCanvas)
* (Social)
  * (Chat Room)
