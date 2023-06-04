% Porting a Solo Game to MUGS

**WIP as of 2021-05-26**


Already have a solo (single-player) game implemented that you'd like to port to
MUGS?  Great!  This guide should help you get started.

As concrete examples, we'll port a couple Raku/Pop games from
[pop-games](https://gitlab.com/jjatria/pop-games),
themselves based on the Lua/LÖVE and Python/Pygame Zero tutorials at
[Simple Game Tutorials](https://simplegametutorials.github.io/),
starting with
[Blackjack](https://gitlab.com/jjatria/pop-games/-/tree/master/blackjack).


# Step 0: TEST YOUR MUGS INSTALL!

If you haven't already done so, follow the [MUGS Install Guide](install-mugs.md)
to get MUGS installed properly and test that you can:

* Play a couple simple text games with `mugs-cli`
* Create a persistent identity universe with `mugs-admin create-universe`
* Start a WebSocket server with `mugs-ws-server`
* Connect to that server with `mugs-cli` or `mugs-web-simple`
* Create MUGS identities to test with

If you haven't done these steps first, the following sections will likely be
quite confusing, and you may find yourself very frustrated if it turns out MUGS
isn't working correctly on your system.


# Step 1: Refactoring

Before doing the actual MUGS port, it's useful to begin with some initial
refactoring within your already-working game.  This will reduce the porting
difficulty, while allowing you to continuously test the working game to make
sure nothing gets lost in the refactoring work.


## Assess Original Code

The biggest change that porting will impose isn't actually particular to the
MUGS APIs, but rather to its basic architecture.  Many "personal project" games
are designed for a single player, or perhaps a couple players sharing a single
computer.  This often results in code that mixes different responsibilities, or
makes simplifying assumptions based on synchronous local play, simply because
there was no strong reason *not* to.  For example, an adventure game might only
simulate the creatures currently visible to the single player instead of across
the whole game map; an action game might detect collisions not by analytically
intersecting bounding hulls but by checking whether UI sprites overlap on the
screen at rendering time; a game UI might assume that it has total knowledge of
the entire game state at all times and that state changes are strictly ordered.

In contrast, MUGS is thoroughly client/server and asynchronous, strictly
separating server-managed game state from the view of any individual player.
Similarly, MUGS separates the game *client* and game *UI*.  A game *client*
packages requests and messages to be sent to the server, validates responses
and push updates from the server, and tracks locally-cached data.  A game *UI*
handles user input and renders an individual's view; it's strictly a player I/O
function.

The first task is thus looking through the existing game code to see what
will need to be disentangled to fit that overall architecture.  Browsing
through the original
[Pop Blackjack program at the time of writing](https://gitlab.com/jjatria/pop-games/-/blob/ceb7eece1cbb50b1228025696f99f178bcbe18e9/blackjack/bin/game),
we can see tightly woven game state and UI code (and since it was written for
local-only play, no concepts of client and server):

| UI? | Lines   | Purpose                                              |
|:----|:--------|:-----------------------------------------------------|
| ✔   | 3-4     | Load Pop modules                                     |
| ✔   | 6-7     | Pop UI boilerplate                                   |
| ✔   | 9-10    | Card sizes in UI                                     |
|     | 11-12   | Define ranks and suits                               |
| ✔   | 14      | Sprite for card back                                 |
|     | 15-17   | Game state                                           |
|     | 19      | Define Win/Lose/Draw enum                            |
| ✔   | 21      | Load card textures                                   |
| ~   | 22      | Shuffle deck, deal hands, set up UI                  |
| ✔   | 24-32   | Define a UI button                                   |
| ~   | 34-39   | Define a Card                                        |
|     | 41-73   | Define a Player, taking a card, and scoring a hand   |
| ✔   | 75-105  | Register key, mouse, and expose event UI callbacks   |
|     | 108-114 | Determine if player hand wins or loses automatically |
|     | 116     | Fill dealer hand                                     |
|     | 118-125 | Determine if player wins or loses against dealer     |
| ✔   | 127-182 | Render current game state in UI                      |
| ✔   | 184     | Start Pop main loop                                  |
| ~   | 186-197 | Define hit and stand actions                         |
| ✔   | 199-200 | Reset UI before shuffling                            |
| ~   | 202-209 | Define cards and card textures                       |
| ✔   | 211-242 | Set visible UI buttons                               |
| ~   | 244-245 | Deal initial cards and set player-done UI callback   |
|     | 247     | Detect instant win condition                         |
| ✔   | 249     | Force dirty flag True                                |
| ✔   | 252-303 | Load simple textures/sprites                         |
| ✔   | 305-397 | Generate procedural card textures/sprites            |

The code also only handles a single player and a single deck of cards.  We can
break those assumptions later; for now, we'll focus just on separation of
concerns.


## Reordering Existing Code

The most basic refactoring task is simply reordering the existing code to bring
UI code together, separate from non-UI code where possible.  I've reordered the
code to place shared or non-UI code toward the top, and pure UI code toward the
bottom:

| UI? | Old Lines | New Lines | Purpose                                              |
|:----|:----------|:----------|:-----------------------------------------------------|
|     |           | 3         | *Add section header comment*                         |
|     | 19        | 5         | Define Win/Lose/Draw enum                            |
|     | 11-12     | 7-8       | Define ranks and suits                               |
|     | 15-17     | 10-12     | Game state                                           |
|     | 41-73     | 14-46     | Define a Player, taking a card, and scoring a hand   |
| ~   | 186-197   | 48-59     | Define hit and stand actions                         |
| ~   | 34-39     | 61-66     | Define a Card                                        |
| ✔   |           | 69        | *Add section header comment*                         |
| ✔   | 3-4       | 72-73     | Load Pop modules                                     |
| ✔   | 6-7       | 75-76     | Pop UI boilerplate                                   |
| ✔   | 9-10      | 78-79     | Card sizes in UI                                     |
| ✔   | 14        | 80        | Sprite for card back                                 |
| ✔   | 24-32     | 82-90     | Define a UI button                                   |
| ✔   | 21        | 92        | Load card textures                                   |
| ~   | 22        | 93        | Shuffle deck, deal hands, set up UI                  |
| ✔   | 75-105    | 95-125    | Register key, mouse, and expose event UI callbacks   |
|     | 108-114   | 127-134   | Determine if player hand wins or loses automatically |
|     | 116       | 136       | Fill dealer hand                                     |
|     | 118-125   | 138-145   | Determine if player wins or loses against dealer     |
| ✔   | 127-182   | 146-202   | Render current game state in UI                      |
| ✔   | 184       | 204       | Start Pop main loop                                  |
| ✔   | 199-200   | 206-207   | Reset UI before shuffling                            |
| ~   | 202-209   | 209-216   | Define cards and card textures                       |
| ~   | 244-245   | 218-219   | Deal initial cards and set player-done UI callback   |
|     | 247       | 221       | Detect instant win condition                         |
| ✔   | 249       |           | Force dirty flag True *(removed, redundant)*         |
| ✔   | 211-242   | 224-255   | Set visible UI buttons *(moved out one scope level)* |
| ✔   | 252-303   | 257-308   | Load simple textures/sprites                         |
| ✔   | 305-397   | 310-402   | Generate procedural card textures/sprites            |

(The program is slightly longer now because I added section header comments.)

Note that mere cut-and-paste is not enough to completely separate the concerns.
For example, determining player win/loss and filling the dealer hand are both
found in the `Pop.update()` UI callback, and the `reset` routine still mixes
card sprite management, button handling, initial deal, and checking for
instant-win; these will all need to be disentangled.


## Separate Game Core From UI

Now that the program is grouped into rough sections, it's time to do the more
detailed disentangling that requires editing individual class and routine
definitions.


### Disentangling `Card`

Here's the original definition for the `Card` class:

```raku
class Card {
    has Str $.rank is required;
    has Str $.suit is required;
    has     $.sprite;
    method WHICH { "$!suit:$.rank" }
}
```

This is almost a pure game core class, except that it's tracking the UI sprite
for each card.  Since `Card` provides a definitive `WHICH` that can be used to
uniquely identify every card with a convenient string, we can instead separate
out the sprite lookup into a hash of its own:

```raku
class Card {
    has Str $.rank is required;
    has Str $.suit is required;
    method WHICH { "$!suit:$.rank" }
}

my  %CARD-SPRITE;        # Sprites for each card face
```

Of course, this requires fixing the dealer and player card render lines so
that instead of pulling the sprite from the `Card`:

```raku
        Pop::Graphics.draw: $c.sprite, ( $x, $y );
```

they instead pull the sprite from the lookup hash:

```raku
        Pop::Graphics.draw: %CARD-SPRITE{$c.WHICH}, ( $x, $y );
```

The `%CARD-SPRITE` lookup hash can be filled at UI startup when the card face
sprites are generated; the end of `sub make-suit` changes from:

```raku
    for RANKS.kv -> $index, $rank {
        $texture.make-sprite: $rank,
            x => $index * CARD-WIDTH, y => 0, w => CARD-WIDTH, h => CARD-HEIGHT;
    }
```

to:

```raku
    for RANKS.kv -> $index, $rank {
        %CARD-SPRITE{"$suit:$rank"} = $texture.make-sprite: $rank,
            x => $index * CARD-WIDTH, y => 0, w => CARD-WIDTH, h => CARD-HEIGHT;
    }
```

The above changes then unlock a partial cleanup of `sub reset` -- when setting
up the deck, all of the texture and sprite bits can be removed to change this:

```raku
    $DECK .= new;
    for SUITS -> $suit {
        my $texture = Pop::Textures.get: $suit;
        for RANKS -> $rank {
            $DECK.set: Card.new: :$suit, :$rank,
                sprite => $texture.get-sprite($rank);
        }
    }
```

to this:

```raku
    $DECK .= new;
    for SUITS -> $suit {
        for RANKS -> $rank {
            $DECK.set: Card.new: :$suit, :$rank;
        }
    }
```


### Disentangling `sub reset`

With the above sprite cleanup, `sub reset` only has two remaining bits of UI
code, the calls to `set-buttons`.  Here's the current routine:

```raku
sub reset {
    set-buttons 'in-round';

    $DECK .= new;
    for SUITS -> $suit {
        for RANKS -> $rank {
            $DECK.set: Card.new: :$suit, :$rank;
        }
    }

    .take: 2 with $player = Player.new: on-done => { set-buttons 'next-round' }
    .take: 2 with $dealer = Player.new;

    $player.end-turn if $player.value == 21;
}
```

The difficult call to move is the second one, since it's part of the
constructor arguments for `$player`, setting up the `on-done` callback, which
can only be set once in `new` because of these lines in `class Player`:

```raku
    has Promise $.done .= new; # Kept once end-turn has been called

    submethod TWEAK (:&on-done) { $!done.then: &on-done }
```

The idea here is to allow additional code blocks to run whenever the original
promise completes.  Let's replace that `TWEAK` with a post-construction method:

```raku
    method on-done(&cb) { $!done.then: &cb }
```

Then replace the final lines of `sub reset` with:

```raku
    .take: 2 with $player = Player.new;
    .take: 2 with $dealer = Player.new;

    $player.on-done: { set-buttons 'next-round' };
    $player.end-turn if $player.value == 21;
```

This allows factoring `shuffle-and-deal` out of `reset`:

```raku
sub shuffle-and-deal {
    $DECK .= new;
    for SUITS -> $suit {
        for RANKS -> $rank {
            $DECK.set: Card.new: :$suit, :$rank;
        }
    }

    .take: 2 with $player = Player.new;
    .take: 2 with $dealer = Player.new;
}

sub reset {
    shuffle-and-deal;

    set-buttons 'in-round';
    $player.on-done: { set-buttons 'next-round' };
    $player.end-turn if $player.value == 21;
}
```

Since `shuffle-and-deal` is pure core game code, it can move up to the non-UI
section, right under the definition of `class Card`.

This works and is certainly a significant cleanup, but we can go even further
by explicitly calling `shuffle-and-deal` separately from `reset` (which can be
renamed to `reset-ui` while we're at it).  Game startup changes from:

```raku
make-deck-textures; # Card textures are generated on load
reset;              # Reset repopulates the deck and deals initial hands
```

to:

```raku
make-deck-textures; # Card textures are generated on load
shuffle-and-deal;   # Repopulates the deck and deals initial hands
reset-ui;           # Resets UI state for a new game
```

The `'SPACE'` key press action changes to:

```raku
    when 'SPACE' {
        shuffle-and-deal;  # New game
        reset-ui;
    }
```

And the action for the `'Play again'` button changes to:

```raku
            action => { shuffle-and-deal; reset-ui },
```

`reset-ui` is now just:

```raku
sub reset-ui {
    set-buttons 'in-round';
    $player.on-done: { set-buttons 'next-round' };
    $player.end-turn if $player.value == 21;
}
```

(We'll deal with that `$player.end-turn` call in a later section.)


### Making `$dirty` UI-only

The `$dirty` global flag is declared near the top in the shared code, simply
because `player-hit` and `player-stand` both set it.  But it's really for the
benefit of the UI as an optimization to prevent constantly repeating rendering.
As far as the core game is concerned, any action at all requires updating the
player, but it's not in charge of that.

The first step is to move the declaration of `$dirty` down to the UI
declaration section, where the sprite globals are declared.

Then remove the flag setting from `player-hit` and `player-stand`, leaving
just:

```raku
sub player-hit {
    return if $player.done;
    $player.take;
    $player.end-turn if $player.value >= 21;
}

sub player-stand {
    return if $player.done;
    $player.end-turn;
}
```

The callbacks now need to be updated to explicitly set the flag directly.
First `key-pressed`:

```raku
Pop.key-pressed: -> $_, $, $ {
    Pop.stop when 'ESCAPE';

    when not $$player.done {
        when 'h' { player-hit;   $dirty = True }
        when 's' { player-stand; $dirty = True }
    }
    when 'SPACE' {
        reset; # New game
    }
}
```

Then the `in-round` button callbacks in `set-buttons`:

```raku
    when 'in-round' {
        Pop::Entities.create: Button.new(
            text => 'Hit!',
            text-pos => Pop::Point.new(22, 238 ),
            box => Pop::Rect.new( 10, 230, 53, 25 ),
            action => { player-hit; $dirty = True },
        );

        Pop::Entities.create: Button.new(
            text => 'Stand',
            text-pos => Pop::Point.new( 79, 238 ),
            box => Pop::Rect.new( 73, 230, 53, 25 ),
            action => { player-stand; $dirty = True },
        );

        $dirty = True;
    }
```


### Reassess

Here's what the code layout looks like now:

| UI? | Old Lines | New Lines | Purpose                                                  |
|:----|:----------|-----------|:---------------------------------------------------------|
|     | 3         | 3         | Section header comment                                   |
|     | 5         | 5         | Define Win/Lose/Draw enum                                |
|     | 7-8       | 7-8       | Define ranks and suits                                   |
|     | 10-12     | 10-11     | Game state                                               |
|     | 14-46     | 13-45     | Define a Player, taking a card, and scoring a hand       |
|     | 48-59     | 47-56     | Define hit and stand actions                             |
|     | 61-66     | 58-62     | Define a Card                                            |
|     |           | 64-74     | Shuffle and deal a new game *(factored out of `reset`)*  |
| ✔   | 69        | 77        | Section header comment                                   |
| ✔   | 72-73     | 79-80     | Load Pop modules                                         |
| ✔   | 75-76     | 82-83     | Pop UI boilerplate                                       |
| ✔   | 78-79     | 85-86     | Card sizes in UI                                         |
| ✔   | 80        | 87        | Sprite for card back                                     |
| ✔   |           | 88        | Card face sprite lookup *(factored out of `Card`)*       |
| ✔   |           | 89        | Dirty flag *(factored to only UI)*                       |
| ✔   | 82-90     | 91-99     | Define a UI button                                       |
| ✔   | 92        | 101       | Load card textures                                       |
|     | 218-219   | 102       | Trigger shuffle deck/deal hands *(split out explicitly)* |
| ✔   | 93        | 103       | Reset UI *(split out explicitly)*                        |
| ✔   | 95-125    | 105-136   | Register key, mouse, and expose event UI callbacks       |
|     | 127-134   | 138-145   | Determine if player hand wins or loses automatically     |
|     | 136       | 147       | Fill dealer hand                                         |
|     | 138-145   | 149-156   | Determine if player wins or loses against dealer         |
| ✔   | 146-202   | 158-213   | Render current game state in UI                          |
| ✔   | 204       | 215       | Start Pop main loop                                      |
| X   | 209-216   |           | Define cards and card textures *(split up)*              |
| ✔   | 206-207   | 218       | Reset button UI                                          |
| ✔   |           | 219       | Set player-done UI callback *(split out)*                |
|     | 221       | 220       | Detect instant win condition                             |
| ✔   | 224-255   | 223-254   | Set visible UI buttons                                   |
| ✔   | 257-308   | 256-307   | Load simple textures/sprites                             |
| ✔   | 310-402   | 309-401   | Generate procedural card textures/sprites                |

The big remaining bits to pull out of the UI code are the triggers for dealing
cards and determination of win or loss.


### Disentangling `update`

First off, there are two places *outside* `update` that are doing things
`update` ought to be doing.  In particular `player-hit` and `reset-ui` both
check if the player's turn is instantly over, but since `update` runs during
every Pop main loop iteration, we can consolidate them.  Here are the previous
versions:

```raku
sub player-hit {
    return if $player.done;
    $player.take;
    $player.end-turn if $player.value >= 21;
}

sub reset-ui {
    set-buttons 'in-round';
    $player.on-done: { set-buttons 'next-round' };
    $player.end-turn if $player.value == 21;
}
```

Remove the last line of each, leaving:

```raku
sub player-hit {
    return if $player.done;
    $player.take;
}

sub reset-ui {
    set-buttons 'in-round';
    $player.on-done: { set-buttons 'next-round' };
}
```

Add the first of those to the very top of `update`, with a check for
`!$player.done` in order to prevent multiple `$player.end-turn` invocations,
and stop checking for `$dirty` before `$player.done`:

```raku
Pop.update: {
    $player.end-turn if !$player.done && $player.value >= 21;
    next unless $player.done && !$dealer.done;
```

Note that the copied line uses the more general `>=` comparison, and it must
happen before the next line checks `$player.done`.

At this point the `Pop.update` block has no references to the UI at all,
except that it exits early with `next` rather than `return`.  By making that
change, we can split it out to its own routine:

```raku
sub maybe-finish-hand {
    $player.end-turn if !$player.done && $player.value >= 21;
    return unless $player.done && !$dealer.done;

    my $player-value = $player.value;
    $dealer.win  when $player-value >  21;
    $dealer.lose when $player-value == 21;

    return if $dealer.done;

    $dealer.take while $dealer.value < 17;

    my $dealer-value = $dealer.value;
    $dealer.draw when $player-value == $dealer-value;
    $dealer.win  when $player-value <  $dealer-value <= 21;

    return if $dealer.done;

    $dealer.lose;
}

Pop.update: { maybe-finish-hand }
```

Of course, `maybe-finish-hand` can now be moved up to the non-UI code section,
completing the separation of concerns:

| UI? | Old Lines | New Lines | Purpose                                              |
|:----|-----------|-----------|:-----------------------------------------------------|
|     | 3         | 3         | Section header comment                               |
|     | 5         | 5         | Define Win/Lose/Draw enum                            |
|     | 7-8       | 7-8       | Define ranks and suits                               |
|     | 10-11     | 10-11     | Game state                                           |
|     | 13-45     | 13-45     | Define a Player, taking a card, and scoring a hand   |
|     | 47-56     | 47-55     | Define hit and stand actions                         |
|     | 58-62     | 57-61     | Define a Card                                        |
|     | 64-74     | 63-73     | Shuffle and deal a new game                          |
|     | 220       | 75-76     | Detect instant turn over condition                   |
|     | 138-145   | 77-83     | Determine if player hand wins or loses automatically |
|     | 147       | 85        | Fill dealer hand                                     |
|     | 149-156   | 87-94     | Determine if player wins or loses against dealer     |
| ✔   | 77        | 97        | Section header comment                               |
| ✔   | 79-80     | 99-100    | Load Pop modules                                     |
| ✔   | 82-83     | 102-103   | Pop UI boilerplate                                   |
| ✔   | 85-86     | 105-106   | Card sizes in UI                                     |
| ✔   | 87        | 107       | Sprite for card back                                 |
| ✔   | 88        | 108       | Card face sprite lookup                              |
| ✔   | 89        | 109       | Dirty flag                                           |
| ✔   | 91-99     | 111-119   | Define a UI button                                   |
| ✔   | 101       | 121       | Load card textures                                   |
|     | 102       | 122       | Trigger shuffle deck/deal hands                      |
| ✔   | 103       | 123       | Reset UI                                             |
| ✔   | 105-136   | 125-156   | Register key, mouse, and expose event UI callbacks   |
| ✔   |           | 158       | Register update callback                             |
| ✔   | 158-213   | 160-215   | Render current game state in UI                      |
| ✔   | 215       | 217       | Start Pop main loop                                  |
| ✔   | 218       | 219       | Reset button UI                                      |
| ✔   | 219       | 220       | Set player-done UI callback                          |
| ✔   | 223-254   | 224-255   | Set visible UI buttons                               |
| ✔   | 256-307   | 257-308   | Load simple textures/sprites                         |
| ✔   | 309-401   | 310-402   | Generate procedural card textures/sprites            |
