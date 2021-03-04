% MUGS Coding Standards

*Reviewed 2021-03-03 by japhb*


The MUGS codebase is large, interconnected, and complex.  In order to -Ofun,
make our code easy to learn and work with, and keep the community inclusive and
safe, there are some common standards, guidelines, and recommendations that
all contributors should follow.


# Do Not Provoke the Lawyers

In order to keep MUGS free and available to everyone, it is *critical* that it
not become a target for legal action.  Game companies are (in)famous for having
active and zealous legal teams, which means we have to be extra careful
operating in this space.  Seriously, I cannot stress this enough:

**DO NOT include any protected intellectual property of any game company,
including but not limited to: trademarks, trade dress, trade secrets, patented
techniques, or copyrighted material including game data, game art, or game
audio, in the core MUGS repositories.**

There are a zillion games in the public domain, under the creative commons, or
that have otherwise been released free-as-in-speech for public use.  Be aware
that some companies have released their game *code* as open source, without
freeing the game *data*; be careful.  Some of these have community-provided
free data sets, which can be used on their own terms, but **DO NOT** import
the original unfree data, in whole or in part, into the core MUGS repositories.

There are also games for which the basic ruleset, mechanics, and play sequence
have been open sourced, but the "flavor" (special descriptions, art, trademarks,
etc.) remain proprietary.  For example, the share-alike
[Open Game License (OGL)](https://en.wikipedia.org/wiki/Open_Game_License) has
been used for a number of games, and distinguishes Open Game Content (OGC) from
Product Identity (PI).  PI belonging to others *must not* be used in MUGS.
Often OGL publishers provide acceptable terms for community users to use in
place of their PI trademarks; please use the community terms where appropriate.

If all of the above make you nervous to contribute, don't worry -- there are
MANY ways to contribute without copying proprietary games, everything from
improving documentation, to adding to the pool of core shared functionality, to
better supporting entire game genres.  If you want more ideas, don't hesitate
to ask; we're a friendly bunch.  If you are still most interested in
implementing an individual game, please put your energies toward support for
more freely available games, or create and share a new game of your own design!

In the rare situation that you have a valid license to redistribute a non-free
game -- such as if you had secured a contract to port the game to the MUGS
ecosystem -- you must distribute it *outside* the core MUGS repositories, and
of course within the terms of your license.  This protects MUGS and its
community if the license or contract is ever revoked or invalidated, if you
accidentally violate a license term, or if case law shifts unfavorably.


# Avoid Hurtful Language

Over the years a number of terms have become commonly used in the technical and
gaming worlds while nevertheless remaining insensitive to groups for whom those
terms have been used hurtfully over the years.  The MUGS community should be an
inviting, supportive place for everyone, and a simple step in that direction is
to stop using those hurtful terms and phrases, and instead use the (usually
more accurate anyway) replacements.  Examples include the following groups of
terms:

Mental health: (in)sane/(in)sanity, crazy, normal
  : Disassociate correctness from mental health.  Generally these can be
    replaced with '(in)correct', '(in)valid', '(un)expected' and so forth.

Disability: crippled
  : Historically this has been used to describe an API or module whose key
    functionality is broken or unusable for some reason, is in a prototype or
    proof-of-concept state, or is not being used to full capacity.  In any
    case, say what you mean instead.

LGBTQIA+: queer/gay
  : These terms can be used to describe queer-positive game content, but do not
    use them when you mean 'strange', 'unusual', 'eccentric', or 'happy'.

Sexism and gender bias: for girls/boys
  : There should be nothing intrinsic about a particular game or design that
    makes it "only for" girls or boys; certainly color scheme and genre do not.
    Games that assume a particular gender for the player don't belong in MUGS.
    (Games that even have the *concept* of gender for characters should allow
    the player to choose whatever gender they would prefer, and not limit the
    character's in-world choices pointlessly because of it.)

Slave history: master/slave
  : It does not matter that these terms have been used in other engineering
    disciplines beyond computer science, they still do not belong in MUGS.
    Many replacements are possible here, such as 'primary/secondary',
    'primary/replica', 'leader/follower', 'source/sink', and 'server/client'.

Institutional racism: redline/blacklist/whitelist
  : Depending on intent, these can be replaced with 'priority list',
    'capacity limit', 'performance threshold', 'ACL', 'ban list', 'deny list',
    'access list', or 'allow list'.

Violence: rape/pillage/assault/murder/kill/death/hostage/prisoner
  : Use *only* in the context of a game in which this is legitimate subject
    matter, and even then be very certain to clearly warn players of the
    content well before they stumble over it.  In MUGS code, these terms
    should not be used at all other than for certain (rather macabre)
    system process management APIs.

Sexual language: many, MANY terms
  : As with violence, use *only* in the context of a game in which this is
    legitimate subject matter, and even then be very certain to clearly warn
    players of the content well before they stumble over it.  Sexual terms have
    even less use in the codebase itself than violent terms, since there is not
    even the system API exception in this case.

The above is merely a starting point.  A great many words are born of a history
of oppression, hatred, and othering.  The above list will likely be updated and
expanded over time, but it is unlikely any existing items will be removed.


## Special Cases

A few special cases surrounding hurtful language will likely come to mind, so
let's get those out of the way:

A game is commonly known by a hurtful name
  : Historically many games have been so named, such as Hangman or Crazy
    Eights.  For some there is already a (more or less well-known) replacement
    name and theme; Hangman can be played as Snowman with identical mechanics
    but minus the lynching overtones.  Others do not have a recognized
    replacement name yet, but closely related or derivative games in the same
    subgenre exist.  For example, in the subgenre of shedding-type card games,
    several other games could be implemented instead of Crazy Eights (though
    note that at least one of them is a non-free variant; see "Do Not Provoke
    the Lawyers" above).

A game specifically explores triggering topics
  : Some games (often those with a mature narrative or realistic historical
    setting) intentionally explore topics that can be triggering for many
    players.  Players (and server admins for that matter) will have very
    different tolerances for such topics.  Games with mature, triggering, or
    hurtful subject matter should be developed and distributed separately from
    the MUGS core game set, and should be clearly tagged so that servers that
    wish to serve them, and players that wish to play them, are fairly
    informed.  To be very clear, the goal here is not censorship but rather
    ensuring informed consent (to borrow the medical terminology).

Hurtful language is discovered in already-committed files
  : This can easily come up in several ways: The author and/or reviewer may not
    have known about the historical or cultural context, the hurt may be
    closely tied to a culture that the author and reviewer are not part of,
    prevailing usage may change, scholars may rediscover previously hidden
    history, etc.  In many cases this will be a case of ignorance rather than
    malice, but that does not obviate the problem.  It is action and effect
    that matter, not intent -- especially since intent becomes ever more
    difficult to judge with the passage of time -- though of course repeated
    ill intent makes the problem much worse.  The offensive language should be
    treated as a standards violation, and at the very least replaced in the
    repo.  (More detail on handling this situation is left to the code of
    conduct.)


# Code Style

In general, contributions should match the formatting and style of surrounding
code or documentation, but there are some simple rules that the existing code
base tries to stick to:


## Documentation Formats

* Write text documentation in Markdown (generally in the intersection of Pandoc
  Markdown and GitHub-Flavored Markdown so that both will handle it correctly).
* Create explanatory diagrams in Graphviz DOT, ready for conversion to SVG
  using `dot -Tsvg`.


## Formatting

* Default indent to 4 spaces for Raku code, 2 spaces for HTML templates.
* Avoid code constructions that cause very deep indentation ladders.
* Never use tabs.
* Remove trailing whitespace.
* If you can keep within 80 characters, do so ... but don't contort the code
  into an unreadable mess to get there.  I'd rather an extra couple characters
  in the line than a word-wrapped abomination.
* Keep `else` and `elsif` uncuddled (a preceding `}` should be on a separate line).
* Vertical alignment of matching constructs helps readability, and makes
  some bugs very obvious; don't be afraid to align on '=' or similar.


## Naming

* Naming matters; take extra time (especially with routine and parameter names)
  to choose good, clear names.
  * One positive indicator is if API callers will likely name their variables
    to match parameter names so they can use the `:$variable` shorthand for
    named arguments, and this will improve the clarity of the caller's code.
* Avoid confusion by naming different things differently; in particular, be
  careful to clearly differentiate an object from the name used to refer to it.
  * For example, a `user` is a persistent identity object carrying security
    information, while a `username` is the text moniker used to log in as a
    user or look up a user in the database.


## Repo Layout

Follow the [Repo Layout](repo-layout.md) document.  If you want to add a new
file or directory that doesn't clearly fit that layout, open a GitHub issue
asking for guidance.


## Tests

* Try to keep the test suite monotonically improving; include tests for all
  new or changed functionality, even if the original code didn't have enough.
* Make sure test files can be run in parallel safely.
* Do not depend on the order in which test files run; each should be fully
  independent of all others.
* Test both features by themselves (unit tests) and combinations of features
  (integration or combinatoric tests).
