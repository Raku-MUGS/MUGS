% Messaging and Communication

*Drafted 2021-03-28 japhb*

**NOTE: This is a rumination on a problem space, not an active design.**


# What's Past is Prologue

[Zawinski's Law](http://catb.org/jargon/html/Z/Zawinskis-Law.html) tells us
*“Every program attempts to expand until it can read mail. Those programs which
cannot so expand are replaced by ones which can.”*  Despite this observation
being made decades ago,
[it still comes up regularly](https://twitter.com/jwz/status/1331287160738070528),
because
[it still rings true](https://medium.com/@tk512/zawinskis-law-a-modern-take-8da3cf89152b).

MUGS, being a platform play from the get-go, won't even try to pretend this
won't happen.  While jwz wasn't just talking about messaging, it is one of the
first ways MUGS is likely going to be expected to expand, if only to make it
easier and more enjoyable for friends to play together.  Better to embrace the
inevitable now and see if we can avoid painting ourselves into a design corner.


# Goals

A number of goals for any MUGS messaging system are clear, but also in partial
conflict.  Part of the design difficulty will be balancing these goals, though
it is not necessary to choose just one point in the solution space.  To satisfy
the majority of the goals the majority of the time, it may be necessary to
offer multiple modes of communication or some form of configurability.
Nevertheless, here are some early goals:

Privacy
  : Players will want some assurance of privacy, at least that no one other
    than intended recipients will be able to read messages they send.  This
    includes privacy from privileged users such as server and universe
    administrators, if at all possible.

Recording as a choice
  : At least one of the *participants* should have to choose to record a
    conversation for it to be recorded in a permanent or semi-permanent way;
    the default behavior should be that messages are ephemeral.  In some
    jurisdictions, it may also be important that all participants are aware
    that someone is (or might be) recording the conversation.

Anti-harrasment
  : Essentially every form of communication has been used for harrasment.
    Messaging designs should try to reduce the ease with which harassers abuse
    the platform and its participants, and allow victims and community leaders
    to stop abusers when they do find a way to attack.

Time-shifting
  : Members of the MUGS community are likely to be on wildly different time
    schedules, necessitating at least some method of sending delayed messages,
    even if the participants are never logged into the same MUGS universe at
    the same instant.

Secure interoperability
  : It's nigh-inevitable that at some point there will be feature requests to
    interoperate with other messaging systems.  Care should be taken to create
    interlinks in the most secure, privacy-preserving fashion possible, with
    full transparency about risks from the interoperation.


# Encryption

Some of the above goals, such as privacy from privileged users, can only be
achieved with strong end-to-end encryption.  At the same time, it is a truism
in the security field that one should never roll one's own encryption and trust
it to actually be secure.  This is true on several levels:

* Don't design a new encryption or security algorithm.
* Don't write a fresh *implementation* of an existing encryption or security
  algorithm.
* Don't use an implementation or algorithm that hasn't been relentlessly
  attacked and battle tested.
* Even when reusing a well-regarded implementation of a well-regarded security
  suite, don't assume surrounding application code won't undermine that
  security.

It's important that any encryption use be upgradeable (and protected from
downgrade attacks); the state of the art changes rapidly enough that no single
cryptosystem can be trusted long term.


# Public, Semi-Public, Private

The scope of intended audience affects messaging design enough that different
audiences may require different messaging paths.  For example, these cases
likely inhabit very different portions of the problem space:

* Persistent messages to all players in a universe
* A broadcast to everyone currently logged into a server
* A game commentator discussing play-by-play in a tournament
* A player inviting their friends to play together
* A team leader directing team tactics
* An out-of-game private chat with 2+ participants

To be precise, here are some of the differences:

| Situation         | Persistent | Read Status | Private | Expires |
|:------------------|:-----------|:------------|:--------|:--------|
| Universe messages | YES        | YES         | no      | maybe   |
| Server broadcast  | no         | no          | no      | no      |
| Game commentator  | YES        | no          | maybe   | no      |
| Friend invites    | YES        | maybe       | YES     | YES     |
| Team tactics      | no         | no          | YES     | YES     |
| Out-of-game chat  | maybe      | YES         | YES     | maybe   |
