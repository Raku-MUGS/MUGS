% Installing MUGS

*Reviewed 2021-05-11 by japhb*


# QUICK START for Raku Users

## Installation

Install MUGS with zef (expect precompilation to take a while):

```
$ zef install --exclude="pq:ver<5>:from<native>" MUGS
```

If you have any trouble, check the next section for help; otherwise skip to
[PLAYING GAMES](#playing-games).


## Trouble Installing?

First, make sure you are using a relatively recent Rakudo; anything older than
2021 is probably too old, and will be missing many stability and performance
fixes.  At the time of writing, this is the version I have installed:

```
$ raku -v
Welcome to Rakudo(tm) v2021.04-10-gbb069a99c.
Implementing the Raku(tm) programming language v6.d.
Built on MoarVM version 2021.04.
```

(You don't need to run a development version as I do; a monthly release is
fine.  I like to stay up to date enough to see if the *next* monthly release is
likely to cause problems for MUGS.)

Some users have had trouble installing modules with a very large transitive
dependency tree (as MUGS has) with a single `zef install`, but have reported
success installing major dependencies first as separate commands before finally
installing MUGS itself on top:

```
$ zef install Cro::TLS
$ zef install cro
$ zef install --exclude="pq:ver<5>:from<native>" Red
$ zef install MUGS
```

Not all of the transitive dependencies are actually used by MUGS; some of these
can be skipped by passing `--exclude` options to `zef install`.  For example,
the `pq` exclude shown above skips a particular transitive dependency that is
known to be unneeded by MUGS and also missing on some systems.


## Still Having Trouble?

We'd like to help!  Visit the `#mugs` channel on
[Libera.Chat IRC](https://libera.chat/guides/clients)
to chat with other MUGS users and developers, or file an
[issue in the MUGS repo](https://github.com/Raku-MUGS/MUGS/issues),
and we'll try to get your problem fixed (and document it here for others who
may be facing the same problem).


# PLAYING GAMES

## Play a Game Locally

You can check that basic installation was successful by playing a trivial test
"game", a simple `echo` service, using the simplest available user interface,
`mugs-cli`.

**Note that the first run may pause for up to 30 seconds at 'Loading MUGS.'**
Later runs should load much faster.

```
$ mugs-cli echo
Loading MUGS.
'Default Character' has joined.
echo game 17 started.
Enter a message > help
Enter a message to send to the server, and it will echo back.

You may also get help for advanced commands with `/help`
or exit a MUGS game by pressing Ctrl-C.

Enter a message > foo
foo
Enter a message > bar
bar
Enter a message > [Ctrl-C]
```

When run as above, just `mugs-cli <game-type>`, MUGS defaults to a simple
in-process server, emulating network connections internally, and using only
ephemeral test data (such as the `Default Character` identity automatically
used to join the game).  All *single player* games should work in this mode;
for example the simple `number-guess` game:

```
$ mugs-cli number-guess
Loading MUGS.
'Default Character' has joined.
number-guess game 17 started.

Enter a natural number between 1 and 100 > 50
Guess 1 was too low.

Previous guesses: 50
Enter a natural number between 1 and 100 > 75
Guess 2 was too high.

Previous guesses: 50 75
Enter a natural number between 1 and 100 > 62
Guess 3 was too low.

Previous guesses: 50 62 75
Enter a natural number between 1 and 100 > 68
Guess 4 was correct.
You win!
```

However, until game-playing bots are implemented, a two player game like
Tic-Tac-Toe (AKA Naughts and Crosses or X's and O's) will soft-hang looking for
another player that can't join because in this mode the server is
internal-only:

```
$ mugs-cli tic-tac-toe
Loading MUGS.
'Default Character' has joined.
Waiting for tic-tac-toe game to start.
>
Waiting for tic-tac-toe game to start.
> [Ctrl-C]
```


## Start a Game Server

To start a joinable game server, you first need to create a persistent
"identity universe" to store information about accounts, login credentials,
etc.:

```
$ mugs-admin create-universe
Loading MUGS.
Universe 'default' created successfully in ~/.mugs/universes with schema version 1.
```

Now you can start the WebSocket-based game server:

```
$ mugs-ws-server
Loading MUGS.
Using universe 'default'.

Loading game server plugins.
Loaded: adventure echo error lobby number-guess snowman tic-tac-toe

Starting WebSocket server.
Listening at wss://localhost:10000/mugs-ws
```

(You may see additional game server plugins if you have installed a separate
game pack or have a newer version of MUGS.)


## Connect to a Game Server

Switching from the internal stub server to your new WebSocket server is as easy
as specifying a `--server=` option to a UI client.  If you don't already have
a login username on that server -- which you won't if you just created a new
identity universe as in the previous section -- the UI will walk you through
creating identities as needed (which will persist for future sessions).  Also,
if no game-type is specified on the command line, MUGS will default to a game
selection lobby:

```
$ mugs-cli --server=wss://localhost:10000/mugs-ws
Loading MUGS.
No username specified for this server; create a new one?
1. Yes, create a new one.
2. No, log in with an existing user.
Selection: 1
Desired username: some-username
Desired password: ***
Confirm password: ***
Logged in as some-username.

In order to play games, you will need to choose your identities.
There are three kinds of MUGS identities, with different uses:

    User:       Logging in, security, and access control
    Persona:    Managing characters, interacting with players outside games
    Character:  Joining and playing games

You are already logged in with your user (some-username).
You will need to create a persona and a character.
Please choose a screen name to create a persona: Enigma
You have created Enigma as your new persona.
Please choose a screen name to create a character: Bob the Magnificent
You have created Bob the Magnificent as your new character.

Known game types:
    TYPE          GENRES                                 DESCRIPTION
    echo                                                 Test "game" that simply echoes input
    tic-tac-toe   turn-based,board,rectangular,mnk-game  Tic-Tac-Toe, Naughts and Crosses, or X's and O's
    number-guess  turn-based,guessing                    High/low number guessing
    snowman       turn-based,guessing                    Letter-by-letter word guessing
    adventure     turn-based,interactive-fiction         Interactive Fiction style adventuring

There are no already active games that are playable in this UI.

Select a game type > echo
Launching echo ...
'Bob the Magnificent' has joined.
echo game 17 started.
Enter a message > foo
foo
Enter a message > bar
bar
Enter a message > [Ctrl-C]

--- LOBBY ----------

Select a game type > [Ctrl-C]
```

Having exited out of the first session, starting a new one reveals the
persisted login username, and using the `/status` slash command shows that the
new persona and character have been remembered as well.  It now also shows the
recently abandoned `echo` game from the previous session:

```
$ mugs-cli --server=wss://localhost:10000/mugs-ws
Loading MUGS.
No username specified for this server; create a new one?
1. Yes, create a new one.
2. No, log in with an existing user.
Selection: 2
Username: some-username
Password: ***
Logged in as some-username.
Known game types:
    TYPE          GENRES                                 DESCRIPTION
    echo                                                 Test "game" that simply echoes input
    tic-tac-toe   turn-based,board,rectangular,mnk-game  Tic-Tac-Toe, Naughts and Crosses, or X's and O's
    number-guess  turn-based,guessing                    High/low number guessing
    snowman       turn-based,guessing                    Letter-by-letter word guessing
    adventure     turn-based,interactive-fiction         Interactive Fiction style adventuring

Active games:
    JOINED  ID  TYPE  STATUS     WAITING
            17  echo  Abandoned

Select a game type > /status
SESSION
    Server:             wss://localhost:10000/mugs-ws
    Logged in as:       some-username
    Default persona:    Enigma
    Default character:  Bob the Magnificent
    Active games:       1 (use `/games` to view)

Select a game type >
```

Now we can select `tic-tac-toe` as a game-type, knowing another user will be
able to join:

```
Select a game type > tic-tac-toe
Launching tic-tac-toe ...
'Bob the Magnificent' has joined.
Waiting for tic-tac-toe game to start.
>
```


## Join an Existing Game

In order to join the existing `tic-tac-toe` game, we'll need another set of
identities (the same character can't enter the same game more than once at a
time).  Again, they'll be persisted for future runs.

**IN A NEW SHELL:**

```
$ mugs-cli --server=wss://localhost:10000/mugs-ws
Loading MUGS.
No username specified for this server; create a new one?
1. Yes, create a new one.
2. No, log in with an existing user.
Selection: 1
Desired username: someone-else
Desired password: ***
Confirm password: ***
Logged in as someone-else.

In order to play games, you will need to choose your identities.
There are three kinds of MUGS identities, with different uses:

    User:       Logging in, security, and access control
    Persona:    Managing characters, interacting with players outside games
    Character:  Joining and playing games

You are already logged in with your user (someone-else).
You will need to create a persona and a character.
Please choose a screen name to create a persona: Mystery
You have created Mystery as your new persona.
Please choose a screen name to create a character: Alex the Great
You have created Alex the Great as your new character.

Known game types:
    TYPE          GENRES                                 DESCRIPTION
    echo                                                 Test "game" that simply echoes input
    tic-tac-toe   turn-based,board,rectangular,mnk-game  Tic-Tac-Toe, Naughts and Crosses, or X's and O's
    number-guess  turn-based,guessing                    High/low number guessing
    snowman       turn-based,guessing                    Letter-by-letter word guessing
    adventure     turn-based,interactive-fiction         Interactive Fiction style adventuring

Active games:
    JOINED  ID   TYPE         STATUS      WAITING
            147  tic-tac-toe  NotStarted  1/2

Select a game type >
```

The new entry in the `Active games:` table shows that the `tic-tac-toe` game is
publicly visible, has not been started, and 1 out of the required 2 players is
waiting for someone else to join.  The `/game <id>` command allows this:

```
Select a game type > /game 147
Joining tic-tac-toe game '147' ...
'Alex the Great' has joined.
tic-tac-toe game 147 started.
3   |   |
2   |   |
1   |   |
  a   b   c
It's your turn.
>
```

The game started as soon as the second player joined, and the original client
has been notified, though this isn't visible yet because the CLI UI is modal.
Simply pressing enter at a prompt will make the update visible.

**IN THE ORIGINAL SHELL:**

```
Select a game type > tic-tac-toe
Launching tic-tac-toe ...
'Bob the Magnificent' has joined.
Waiting for tic-tac-toe game to start.
>
'Alex the Great' has joined.
tic-tac-toe game 147 started.
3   |   |
2   |   |
1   |   |
  a   b   c
Waiting for 'Alex the Great' to play their turn.
>
```

Let's play the classic opening move, right in the center.

**IN THE SECOND SHELL:**

```
> b2
3   |   |
2   | X |
1   |   |
  a   b   c
Waiting for 'Bob the Magnificent' to play their turn.
>
```

Bob can now look at Alex's play and respond:

**IN THE ORIGINAL SHELL:**

```
>
3   |   |
2   | X |
1   |   |
  a   b   c
It's your turn.
> a1
3   |   |
2   | X |
1 O |   |
  a   b   c
Waiting for 'Alex the Great' to play their turn.
>
```

And so it goes ....
