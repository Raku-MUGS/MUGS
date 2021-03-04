% Contribution Guidelines


# A Note From the Founder

First off:  Thank you!  Thank you for using MUGS, and thank you for wanting
to contribute to this project and our community.  For me it is a passion
project, a labor of love, and I very much appreciate contributions in all forms.

MUGS is still in its infancy, and I want to encourage community contributions
right from the outset, so these guidelines are mostly focused on making
contribution as easy as possible while still keeping the repos maintainable
and culture positive and inclusive.  When the community has grown and there are
more regular contributors, we can refine these guidelines accordingly.

A few simple rules will cover a lot of it:

* Read and follow the [Coding Standards](https://github.com/Raku-MUGS/MUGS/tree/main/docs/design/coding-standards.md).
* When filing an issue, include enough information to make triage easy.
* Less Than Awesome (LTA) is a valid bug; strive for the best MUGS experience.
* PEOPLE MATTER.  Treat each other respectfully, inclusively, and well.

To expand that last point:  No amount of supposed brilliance makes up for acting
like a jerk or insensitive clod.  I will **NOT** tolerate poisonous behavior
in the MUGS community.


# Specific Cases

## I'm Not a Coder

No problem!  There are MANY ways to contribute to MUGS, from bug reporting
to documentation to artistic contributions.  Whether your passion is pixel
art, game design, sound design, website design, project organization,
accessibility testing, copy editing, playtesting, ... ALL of these are welcome,
and all are valued.


## I Found a Bug/Issue

Please file a GitHub Issue against the appropriate repo (or the general MUGS
repo if nothing more specific applies).  Please include examples of the
behavior you expected and the behavior you actually saw.  If you can include
a snippet of code that triggers the bug, or reproducible steps to recreate
the issue, that would be extremely helpful.

Please also include your OS type and version, and your MUGS and Rakudo
versions, by including the output of the following commands:

```
$ raku -e 'say $*DISTRO'
$ raku -v
$ zef info MUGS
```

I'll triage the issue (usually within 48 hours), and reply to you on the
issue with my assessment and/or with additional debugging questions.


## I Have a General Suggestion

As with bugs, please file a GitHub Issue against the appropriate repo (or the
general MUGS repo if nothing more specific applies).  Please include a
description of what change or improvement you'd like to see, and how (and why)
it differs from current behavior or functionality.  If you're requesting an API
change or addition, please include example code showing how you'd like to use
the API.

I'll triage the suggestion (usually within 48 hours), and reply to you on the
issue with my assessment and/or with additional exploratory questions.


## You Should Add This Game or Genre

Please file a GitHub Issue against the MUGS-Games repo with your suggestion.
Please *DO NOT* suggest games that are proprietary -- I'd just have to close
the request anway -- but if you have identified a free-as-in-speech variant or
relative within the same subgenre, please point to documentation showing that
the variant truly is "in the clear" legally, and I'll take a look.

I'm always happy to consider new games and game genres, but remember that one
of the large design goals of MUGS is that it should become much easier for
*anyone* to implement games, because so much of the busywork is already done
and/or can be amortized across many games within a (sub-)genre.  Thus I want to
open up the actual implementations to the community.

I am certainly willing to coach/mentor anyone who wants to learn how to
implement a game using MUGS, so if that interests you, don't worry that you'd
be going it alone!


## I Have a Small Patch (Set)

Great!  Before you send it over, please read the
[Coding Standards](https://github.com/Raku-MUGS/MUGS/tree/main/docs/design/coding-standards.md)
and make sure your change follows the rules therein.  Please also attempt to
match the style of surrounding code or documentation in your pull requests.

Once you've checked your change against the coding standards, please submit
your patches in the form of GitHub PRs (Pull Requests).  Make sure that all
commit messages and the PR description are clear and to the point, explaining
not just the what but the why as well.  Keep PRs for unrelated changes
separate, and the commits within each cleaned up (e.g. squash away debugging
commits).

I'll review each PR (usually within 48 hours), and either merge it or comment
with any concerns or suggestions.  I'm happy to iterate on a change to get it
right, so please don't worry if I don't merge it immediately!

Please also note that by submitting a PR you are agreeing that your changes can
be incorporated into the MUGS repos and copied/modified/distributed as per the
overall MUGS license (the Artistic License 2.0), and in particular that you
have the legal right to make that agreement.  (This might not be the case for
example if you are contractually bound to contribute all of your work to a
particular company and do not have a waver from them specifically for MUGS
contributions.)


## I Plan Major Changes

Before you start heavy work, make sure it's likely to be accepted (and thus
neither wasting your time and effort nor feeling forced to fork MUGS) by first
opening a GitHub Issue against the appropriate repo (or the general MUGS repo)
explaining the work you intend to do, and why you believe this is the right
approach.

I'll review your proposal and either approve the direction as is, suggest
tweaks to fit the overall MUGS design better, ask for more details, or reject
the idea as it currently stands, but with constructive comments to help find a
path forward.
