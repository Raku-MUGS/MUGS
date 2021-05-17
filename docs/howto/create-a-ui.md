% Creating a New MUGS UI

**WIP as of 2021-05-16**


There are actually two common cases here:

1. [Creating a new UI type](#creating-a-new-ui-type) that has never been used
   with MUGS before and a driver app for players wanting to use that UI; for
   example, adding a Qt or Win32 UI type

2. [Creating a game UI plugin](#creating-a-new-game-plugin-for-an-existing-ui)
   for an *existing* UI type for an *existing* game that doesn't run in that UI
   yet; for example, adding a TUI plugin for a MUGS action game that previously
   only worked in a graphical UI such as SDL or GTK+


# Creating a New UI Type

This is the path to take when you want to introduce support for an additional
UI toolkit (such as Qt or Win32), or add a whole new interface paradigm to
MUGS (such as VR display or multitouch tablet support).  For concreteness
below, we'll walk through the creation of the actual MUGS-UI-Pop repo.


## Raku Support for the UI

The first task is to ensure that the new UI is supported in Raku at all; if the
API isn't available as a module (or module suite) that you can depend on,
address that first -- creating MUGS-specific narrow bindings for a major
toolkit API is *possible*, but probably a frustrating yak-shave.  Besides,
making a general binding is much better for the overall Raku community.

[Pop](https://gitlab.com/jjatria/pop) is a Raku-native game UI toolkit, and has
built-in bindings for all of the [SDL](https://www.libsdl.org/) functionality
it uses, so as long as we have the needed SDL libraries available it should
Just Work.


## Getting Familiar with the UI API

If you're new to the interface type or toolkit API, take some time to
familiarize yourself with the basics.  Try some tutorials or simple test apps
in the new API before starting on the MUGS plugin.

Web UIs can be supported via Cro (which is already a MUGS dependency), but if
you plan to use a highly dynamic Javascript framework with it, you should get
comfortable with that framework before trying to add MUGS support for it.

Pop includes
[module docs](https://gitlab.com/jjatria/pop/-/tree/master/doc) and
[tutorial examples](https://gitlab.com/jjatria/pop/-/tree/master/examples)
in the main repo, and there are additional repos with
[mini games](https://gitlab.com/jjatria/pop-games) and a
[full platformer](https://gitlab.com/jjatria/celeste-clone).
There's enough there to get a good basic familiarity.


## Create a New UI Repo

Each UI should be in its own repo, so you'll need to create one using one of
these patterns:

`MUGS-UI-Web<Foo>`
: For a *Foo* UI that runs in a web browser, such as `MUGS-UI-WebSimple` or
  `MUGS-UI-WebCanvas`

`MUGS-UI-<Bar>`
: For any local *Bar* UI toolkit, such as `MUGS-UI-CLI` or `MUGS-UI-GTK`

The MUGS development tool `mugs-tool` can give you a starting point for this;
here I'll use it to create the Pop UI repo:

```
$ mugs-tool new-ui-type Pop --desc "Pop/SDL UI for MUGS, including App and game UIs"

=== mi6 new "MUGS::UI::Pop"
Successfully created MUGS-UI-Pop

=== git commit -m "Initial mi6 template"
[master (root-commit) 247a6a5] Initial mi6 template
 9 files changed, 356 insertions(+)
 create mode 100644 .github/workflows/test.yml
 create mode 100644 .gitignore
 create mode 100644 Changes
 create mode 100644 LICENSE
 create mode 100644 META6.json
 create mode 100644 README.md
 create mode 100644 dist.ini
 create mode 100644 lib/MUGS/UI/Pop.rakumod
 create mode 100644 t/01-basic.rakutest

=== git branch -M main

=== Creating directories
docs
lib/MUGS/App
lib/MUGS/UI/Pop
lib/MUGS/UI/Pop/Game
lib/MUGS/UI/Pop/Genre

=== Adding MUGS-specific files
bin/mugs-pop
lib/MUGS/App/Pop.rakumod
t/00-use.rakutest

=== chmod "+x" "bin/mugs-pop"

=== git add "bin/mugs-pop" "lib/MUGS/App/Pop.rakumod" "t/00-use.rakutest"

=== git rm "t/01-basic.rakutest"
rm 't/01-basic.rakutest'

=== git commit -m "Add MUGS-specific files"
[main 0c5ec0e] Add MUGS-specific files
 4 files changed, 77 insertions(+), 6 deletions(-)
 create mode 100755 bin/mugs-pop
 create mode 100644 lib/MUGS/App/Pop.rakumod
 create mode 100644 t/00-use.rakutest
 delete mode 100644 t/01-basic.rakutest

=== git status
On branch main
nothing to commit, working tree clean

--> All commands executed successfully.
```


## Review Skeleton

Take a look around the newly generated tree and get acquainted with the
contents.  Here's a quick overview:

```
MUGS-UI-Pop                   # New UI repo root
├── bin                       # Minimal launcher scripts
│   └── mugs-pop              # Launcher script for Pop UI
├── Changes                   # (Hand-updated) record of version changes
├── dist.ini                  # mi6 config file
├── docs                      # Stub for docs tree
├── .github
│   └── workflows             # GitHub Workflows
│       └── test.yml          # On-commit tests
├── .gitignore                # Patterns for files to ignore in repo
├── lib
│   └── MUGS                  # Main MUGS code libraries
│       ├── App               # App implementations
│       │   └── Pop.rakumod   # Pop UI app
│       └── UI                # Game UIs
│           ├── Pop.rakumod   # Base class for all Pop game UIs
│           └── Pop
│               ├── Game      # Game-specific UI plugins
│               └── Genre     # Genre-shared UI code
├── LICENSE                   # Artistic License 2.0
├── META6.json                # Module metadata
├── README.md                 # Auto-generated from MUGS::UI::Pop docs
└── t                         # User-visible tests
    └── 00-use.rakutest       # Use all modules and versioned dependencies
```

Almost all of the code resides in `lib/MUGS/`; here's the entire contents of
the launcher script, `bin/mugs-pop`:

```raku
#!/usr/bin/env raku
use v6.d;
BEGIN put 'Loading MUGS.' if $*OUT.t;
use MUGS::App::Pop;
```

We'll take a look at the `Pop.rakumod` modules below.


## Tweak the New UI Repo

After you've created the initial skeleton, you can make any changes to your
personal preferences (or emulate the first few commits of one of the MUGS core
UI repos), and commit them so you're back at a clean `git status` for the next
step.  Here's what I did for the Pop UI:

```
$ cd MUGS-UI-Pop

$ # I use a doc auto-converter, so ignore its output
$ cat >> .gitignore

# Generated files
/*.html
/docs/*.html
/docs/*/*.html
/docs/*/*.dot.svg
$ git add .gitignore
$ git commit -m "Add generated files to .gitignore"

$ # Add MUGS standard CODE_OF_CONDUCT and CONTRIBUTING docs
$ cp ../MUGS-UI-CLI/CODE_OF_CONDUCT.md .
$ cp ../MUGS-UI-CLI/docs/CONTRIBUTING.md docs/
$ git add CODE_OF_CONDUCT.md docs/CONTRIBUTING.md
$ git commit -m "Add MUGS standard CODE_OF_CONDUCT and CONTRIBUTING"
```


## What's Working?

Time to try the skeletal app:

```
$ raku -Ilib bin/mugs-pop
Loading MUGS.
Usage:
  bin/mugs-pop <game-type> -- Play a requested Pop game

Common options for all commands:
  --server=<Str>    Specify an external server (defaults to internal)
  --universe=<Str>  Specify a local universe (internal server only)
  --debug           Enable debug output
```

It wants the user to specify a `game-type` to play, but we haven't implemented
any game plugins for this new UI yet, so that will have to wait.  Here's what
happens when trying to request a particular `game-type` but the plugin doesn't
exist yet:

```
$ raku -Ilib bin/mugs-pop lobby
Loading MUGS.
Cannot launch 'lobby'; missing UI plugin.
```

In other words, it doesn't crash, but it also doesn't do much.  Time to fix
that.


## Stub the New UI

`mugs-tool new-ui-type` tries to relieve some of the boilerplate toil involved
in creating a new UI type, but since UI toolkits vary considerably there are
many pieces that must be filled in by a human.

Here's the App file as it was generated by `mugs-tool`; particularly note the
lines marked with `# XXXX:`

```raku
# ABSTRACT: Core logic to set up and run a Pop game

# XXXX: use Pop app module here

use MUGS::Core;
use MUGS::App::LocalUI;
use MUGS::UI::Pop;


# Use subcommand MAIN args
%PROCESS::SUB-MAIN-OPTS = :named-anywhere;


#| Pop App
class MUGS::App::Pop is MUGS::App::LocalUI {

    method ui-type() { 'Pop' }

    #| Connect to server and authenticate as a valid user
    method ensure-authenticated-session(Str $server, Str $universe) {
        my $decoded = self.decode-and-connect($server, $universe);
        my ($username, $password) = self.initial-userpass($decoded);

        # XXXX: Should allow player to correct errors and retry or exit
        await $.session.authenticate(:$username, :$password);
    }

    #| Start actively playing current game UI
    method play-current-game() {
        # XXXX: Enter Pop main loop here
    }
}


#| Common options that work for all subcommands
my $common-args = :(Str :$server, Str :$universe, Bool :$debug);

#| Add description of common arguments/options to standard USAGE
sub GENERATE-USAGE(&main, |capture) is export {
    &*GENERATE-USAGE(&main, |capture).subst(' <options>', '', :g)
    ~ q:to/OPTIONS/.trim-trailing;


        Common options for all commands:
          --server=<Str>    Specify an external server (defaults to internal)
          --universe=<Str>  Specify a local universe (internal server only)
          --debug           Enable debug output
        OPTIONS
}


#| Play a requested Pop game
multi MAIN($game-type, |options where $common-args) is export {
    play-via-local-ui(MUGS::App::Pop, :$game-type, |options)
}
```

The last 20 lines of the file will work just fine for now; they provide the
default command line options and argument behavior.  The header and class are
where all the interesting changes are needed.  First load the UI toolkit's
essential modules at the top:

```raku
use Pop;
use Pop::Graphics;
```

Second, override the `initialize` and `shutdown` methods to add handling of the
Pop window.  Since the `Pop` object is a self-bootstrapping singleton object,
`initialize` can call `Pop.new` without storing the result, and for now at
least there's no app-global attributes needed.

```raku
    #| Initialize the overall MUGS client app
    method initialize() {
        callsame;
        Pop.new(:title('MUGS'));
    }

    #| Shut down the overall MUGS client app (as cleanly as possible)
    method shutdown() {
        Pop.stop;
        Pop.destroy;
        callsame;
    }
```

Next, stub a render callback and start the Pop main loop in `play-current-game`:

```raku
    #| Start actively playing current game UI
    method play-current-game() {
        Pop.render: { Pop::Graphics.clear }
        Pop.run;
    }
```


**WIP: MORE TO COME**


XXXX: Dockerfiles?


# Creating a New Game Plugin for an Existing UI

This is the simpler case of course; the existing MUGS UI and its app are
already known to work for other games, limiting the scope of bug hunts.
Furthemore, the existing game's client and server modules are already known to
work for other UIs, assuming this isn't the very first UI being created for the
game -- or if it is, the client and server plugins have at least already been
tested to work together.  It is only the combination of *this* UI with *that*
game that isn't working yet.


## Understand the Existing Code

Before starting to write the new plugin, take some time to understand the
existing working code.  Examine the existing client and server plugins to
understand what actions the client can take, how they can fail, and what
asynchronous updates are likely from the server.

Also take a look at other games already working in the UI.  It's especially
useful to examine plugins for similar games, especially if they share common
genres with your game.  Understand how games of those genres work in that UI.


## Sketch Your Design

Take a few minutes to sketch out your UI flow and layout.  What do you expect
the game display to look like?  How does the player choose their actions?
How would the player use assistive technologies, such as a screen reader or
alternate input device?  How are errors and other failures handled?

You'll likely iterate the design over time, but investing a few minutes up
front can reduce the "blank page problem" that makes it difficult to get
started.


## Stub the New UI Plugin

It's easiest to build a UI plugin when you have something that you can interact
with at all times.  To that end, the first actual coding task will be to stub
in the new UI plugin, enough that the UI app recognizes it as a valid UI plugin
and lets you join the proper game type with it.  Even if the only thing it can
do is put up a message that it's alive and display the GameID the client has
joined, that's enough to start.

**XXXX: Explain how to stub a plugin**


## Display Initial Game State

Write enough display logic to show the initial game state, at least at a very
basic level.  For example, you might display a checkerboard with pieces in the
appropriate positions for Chess or Draughts, or display the player's hand for
a card game.

**XXXX: Show example code**


## Hook Up a Trivial Action

Add enough functionality to do something trivial in the game, even if it's
ugly and hardcoded.  "Push this button to play the first move in the center"
is perfectly acceptable.  At this point, you're just making sure you can wire
up the UI's input to trigger an action that you send through the existing client
to the server, are able to process the server's response, and can display the
changed game state.

**XXXX: Show example code**


## Lather, Rinse, Repeat

At this point, you should be able to start up a loop of hooking up additional
actions, followed by cleaning up, generalizing, or refactoring your existing
code, before going back and adding more.  Don't forget to test alternate input
methods (keyboard instead of mouse, for instance) and output modalities (with
a screen reader or without audio, for instance).


## Polish and Publish

Do a final pass over your new plugin, especially with an eye towards the
[MUGS coding standards](../design/coding-standards.md).  When you're more or
less satisfied with the current state, it's time to publish your new plugin:

* If the existing game *and* UI are already part of the
  [MUGS core repositories](https://github.com/Raku-MUGS), submit your new
  plugin as a PR to the appropriate UI repository, such as
  [MUGS-UI-CLI](https://github.com/Raku-MUGS/MUGS-UI-CLI) for a new CLI plugin.

* If the existing game is *not* part of the MUGS core but the UI type *is*, you
  can offer your plugin as a separate module uploaded to zef/fez or CPAN.  Make
  sure to depend on both the MUGS UI module and the game implementation in your
  `META6` file.

* If the UI type is *not* part of the MUGS core, consider submitting your new
  plugin to the owners of that UI repository; you can also offer it as a
  separate module, just as in the case where the game itself is not in the MUGS
  core.


## Sing, Rejoice, and Announce

That's it!  Now go tell `#mugs` on Freenode IRC about your new plugin.  :-)
