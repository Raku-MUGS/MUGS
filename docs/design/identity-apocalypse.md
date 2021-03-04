% Preventing an Identity Apocalypse

*Reviewed 2021-03-03 by japhb*

**NOTE: THIS IS A SPECULATIVE RUMINATION, NOT AN ACTIVE DESIGN**


Identities are a limited resource for two major reasons:

1. All names in an identity universe need to be unique in not just a literal
   sense, but in a human sense, so that people can reliably contact each other
   and have some trust that they are reaching the right person.
2. For performance, cost, and fairness reasons, no single bad actor should be
   able to create an unlimited number of identities.


# Maintaining Uniqueness

At identity creation time (and in the same transaction), MUGS should attempt an
insert into a global name table, with columns at least containing:

* Identity type
* Exact chosen name
* De-confused name (unique constraint)

If insertion in that table fails, identity creation transaction fails, and the
player gets an "unavailable identity" error.

The de-confusion mapping should have multiple stages, including at least:

* Case and mark mapping
* NFKC compatibility mapping
* Unicode confusable mapping


# Preventing Abuse

At the most basic level, there should be soft and hard limits for each of:

* Characters per Persona
* Personas per Account
* Users per Account
* Identities of each type created per unit time

Unfortunately the hardest thing to enforce is "Accounts per Human", without
which the above can all be easily subverted.  Without an actual purchase or
subscription model which would limit identity creation based on sheer cost,
MUGS needs some other model for preventing rampant sock puppetry, a DoS of the
identity universe, or other similar abuse scenarios.

One possible model is multi-tiered reputation, where reputation means different
things for different identity types.


## Account Creation

To create an account in the first place, the creation attempt would need to
have a positive reputation, which could be determined heuristically by
examining the account creation attempt itself:

* What peer IP and IP Geo it's coming from
* Volume of recent account creations/closures from that IP and IP Geo
* Number of idle or low-reputation accounts from that IP and IP Geo
* CAPTCHA solving or other proof-of-effort work
* Account-owner username heuristics, such as length or entropy (tricky)
* ...?

This is very hard to do well without introducing severe bias and/or hurting
innocent players as a side effect -- large companies have entire teams that do
nothing but tweak their abuse-detection models -- but it's likely that even
simple heuristics would reduce the incidence of "lazy abuse", where the bad
actor isn't determined or malicious enough to e.g. create a botnet to attack
the server.  Note also that any anti-abuse heuristics that aren't based on
hidden data, proprietary code, or other secret info must be assumed visible to
attackers as well, who can tune their attacks accordingly.


## Personas and Characters

Assuming initial account creation is successful, it can start with enough
initial reputation to create a first Persona and Character, or maybe a bit more
if the universe admin wants people to be able to create more than one of each
out of the gate.  It's tempting to base the initial account reputation
dynamically on the heuristics from the creation of that account, but this could
fall prey to unduly rewarding a bad actor who tricks the heuristics.

Earning more reputation for the account allows the creation of additional
personalities.  For instance, each of these might grant the account some
reputation to spend, each designed to prevent simple abuse via play-and-lose
bots or trivial farming:

* Winning some number of different turn-based games
* Reaching a certain ranking or Elo-style rating in tournament games
* Earning a certain number of points in twitch games
* Spending a certain amount of time and non-trivial moves in persistent worlds
* Unlocking various achievements

The above are all based on the player's own actions or skill relative to the
other active players.  It might be possible to supplement this with social
reputation of some sort, but great care is needed to prevent:

* Rich get richer feedback loops
* Popularity contests and reinforcement of insincere behavior
* Reputation kiting via multiple malicious accounts working together
