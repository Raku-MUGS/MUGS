% Turns, Rounds, Matches

*Reviewed 2021-03-27 by japhb*

**NOTE: Most of the levels of this hierarchy are NYI, and the suggested naming
        convention should be matched up with more varied precedents to confirm
        it will work for most cases.**


Many games have different names for turns, aggregations of turns, separable
games within a tournament, etc.  Despite this naming disparity externally, MUGS
should internally use consistent terminology to avoid confused implementations.


# Precedents

The following are some naming conventions in existing use, which can help guide
choices for names in MUGS.

Baseball
  : Pitch, batter, out, bottom/top, inning, game, series, season

Tennis
  : Point, game, set, match, round, tournament

Track and Field
  : Heat, event, meet, season

Poker
  : Turn, betting round, phase, hand, table, tournament

Board Game A
  : Action, turn, round, phase, game

Card Game B
  : Turn, age, game

Card Game C
  : Action, phase, turn, game, match, event, stage, course, season

Card Game D
  : Turn, trick, hand, game, tournament


# MUGS Convention

By convention, MUGS will use the following terminology:

Event
  : The smallest unit of state change within the game engine; may or may not be
    exposed in the game rules explicitly.

Action
  : The smallest unit of player activity (which may trigger multiple events).
    In games that have a reaction concept, the original player's action and
    another player's reaction are each considered separate at this level.

TurnPhase
  : In games that separate a single turn into distinct phases, this represents
    a single sub-turn phase.

Turn
  : In turn-based games, one or more actions (or turn phases) that together
    make up a single player's activity before another player gets to go.

Round
  : Turns for each player in the game (even if that turn is a pass or skip)
    before it becomes the start player's turn again *and* in process multi-turn
    plays have completed.  Trick games may consider a round to be equivalent to
    a trick, with start player often changing each round depending on which
    player won the last trick.  Shedding games and betting games may go around
    the table multiple times before the round logically completes.

GamePhase
  : If an entire *game* is split into phases, this represents that concept.

Game
  : A single end-to-end game with an in-game completion rule: resignation, out
    of cards/tokens/energy/time, finished last GamePhase, reached end point,
    reached point goal, etc.  For games like poker where the deck state resets
    after every hand, and (in open play at least) players may be able to join
    or leave in between hands, each hand can be considered a separate "game".

Match
  : Multiple games that represent a unit of competitive play between a set of
    players or teams.  This could be best-of-N for games that have a clear
    win/loss concept, or it could be elimination of all but the last player in
    a heat for elimination games.

Meet
  : A tournament, gathering, or other such meet-up.  Usually made up of many
    pairings or groupings of players/teams into matches, often with some form
    of ranking or elimination, and could take place over hours, days, or weeks.

Season
  : All the meets/tournaments that make up a gaming season.  Some sports/games
    only have one playing season per year, others start a new play season every
    six months, and some have a new season every month.  Often win-loss records
    are reset every season, team or rule changes occur between seasons, and so
    forth.
