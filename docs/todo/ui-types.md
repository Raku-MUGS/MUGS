% UI Type TODOs

*Reviewed 2021-03-03 by japhb*


These todo items are for the creation or refinement of UI types.  Each of these
usually uses a different UI toolkit or technology, but there are common concepts
and user journeys that each of them should be able to support.

* Common
  * UI phases/states
    * initialization -- WIP
    * picking game (lobby) -- WIP
    * waiting for game to fill
    * configuring a game -- WIP
    * starting game
    * playing game -- WIP
    * paused
    * switching active game -- WIP
    * ending game
    * shutdown -- WIP
  * UX
    * Verbose, standard, terse/compact output?
    * Trigger warnings / content advisories for certain games
    * Game picking shows which games are active and available to join
  * Lobbies
    * Pick game -- WIP
    * Out-of-game chat
    * Accomplishments/rewards
    * High score lists
  * A11y
    * All UIs (except TUI probably) support screen reader
    * All games working with multiple a11y technologies on at least one UI
  * I18n
    * Translated interfaces
      * Main user UI
      * /commands
      * Error messages
      * Admin UI
      * CLI USAGE
      * CLI flags?
      * README
      * Getting Started guide
      * Hooks for using a translation service
    * Test languages:
      * Doubled (every phrase copied twice, or using fullwidth characters,
        to take up more space)
      * Rotated 180 degrees
      * RTL (should be able to affect layout too, not just text output)
      * RTL Pig Latin?
    * Locale awareness
      * Region v. dialect v. script v. language
      * Preferred formats for lists, numbers, dates, etc.
* Types
  * TUI -- WIP
    * Login and quit
    * User, persona, and character creation flows
    * Lobby and game switch
    * ESC key pauses current game and opens /command prompt?
  * WebSimple -- WIP
    * Lobby as explicit game?
    * Proper web forms (Cro::HTTP::WebApp::Form?)
    * Needs security review
    * Should protect against accidental replay or out of order play, such as
      two browser tabs pointing at same game-id
    * Needs perf testing for JSON, static file, and templated HTML responses
  * (WebSPA?)
  * (WebCanvas)
  * (WebGL)
  * (GTK?)
  * (Qt?)
