% Creating a New MUGS UI

**WIP as of 2021-05-11**


There are actually two common cases here:

1. Creating a plugin for an existing UI type for an existing game that doesn't
   run in that UI yet; for example, adding a TUI plugin for a MUGS action game
   that previously only worked in a graphical UI such as SDL or GTK+

2. Creating a new UI type that has never been used with MUGS before and a
   driver app for players wanting to use that UI; for example, adding a Qt or
   Win32 UI type


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
  sure to depend on the MUGS UI module and the game implementation in your
  `META6` file.

* If the UI type is *not* part of the MUGS core, consider submitting your new
  plugin to the owners of that UI repository; you can also offer it as a
  separate module, just as in the case where the game itself is not in the MUGS
  core.


## Sing, Rejoice, and Announce

That's it!  Now go tell `#mugs` on Freenode IRC about your new plugin.  :-)


# Creating a New UI Type

This is the path to take when you want to introduce support for an additional
UI toolkit (such as Qt or Win32), or add a whole new interface paradigm to
MUGS (such as VR display or multitouch tablet support).


## Raku Support for the UI

The first task is to ensure that the new UI is supported in Raku at all; if the
API isn't available as a module (or module suite) that you can depend on,
address that first -- creating MUGS-specific narrow bindings for a major
toolkit API is *possible*, but probably a frustrating yak-shave.  Besides,
making a general binding is much better for the overall Raku community.


## Getting Familiar with the UI API

If you're new to the interface type or toolkit API, take some time to
familiarize yourself with the basics.  Try some tutorials or simple test apps
in the new API before starting on the MUGS plugin.

Web UIs can be supported via Cro (which is already a MUGS dependency), but if
you plan to use a highly dynamic Javascript framework with it, you should get
comfortable with that framework before trying to add MUGS support for it.


## Create a New UI Repo

Each UI should be in its own repo, so you'll need to create one using one of
these patterns:

`MUGS-UI-Web<Foo>`
: For a *Foo* UI that runs in a web browser, such as `MUGS-UI-WebSimple` or
  `MUGS-UI-WebCanvas`

`MUGS-UI-<Bar>`
: For any local *Bar* UI toolkit, such as `MUGS-UI-CLI` or `MUGS-UI-GTK`

`mi6` will give you a decent starting point for this:

```
$ cd MUGS  # or wherever you keep your MUGS Git repos
$ mi6 new MUGS::UI::Bar
Successfully created MUGS-UI-Bar
$ cd MUGS-UI-Bar
$ git commit -m "Initial mi6 template"
$ git branch -M main
$ git status
On branch main
nothing to commit, working tree clean
```

Look around the initial tree, make any changes to your personal preferences
(or emulate the first few commits of new MUGS core UI repos), and commit them
so you're back at a clean `git status` for the next step.


## Stub the New UI

Using `mi6 new` as above gives a very generic Raku module structure; it does
not yet include the specific bits you'll need to make a new MUGS UI.

**WIP: MORE TO COME**
