% Data Validation

*Reviewed 2021-05-12 by japhb*

**NOTE: Validation is a WIP, though significantly improved in 0.1.2**


# Problem

As with any communicating processes, MUGS clients and servers have no intrinsic
reason to trust each other or their communication channel.  Thus both need to
validate all received data for syntactic and semantic correctness before acting
on them.  Even in cases where data can be proven to be the right structure and
type, we should assume that the actual data itself may have been manipulated to
cause trouble.  For example, strings may contain control characters or
delimiters, sizes and durations may be negative or huge, multidimensional
arrays may have ragged row sizes, and so forth.

Of course, there are important performance considerations.  Copying all of the
data as it is validated may ensure that the calling code never has access to
the raw unvalidated data, but it also (at least) doubles the memory
requirements for message processing and causes quite a bit of GC churn to boot.
Clients may be processing a large volume of messages, and servers certainly
will; excessive overhead will cause noticeable lag, or limit the maximum
goodput available.

In designing the validation API, it's important that the "easy" or at least
"obvious" path be the safe and correct path as well.  This implies that
validation shouldn't be so far away from consumption that the two codepaths
will be very likely to skew or bitrot over time.


# Levels

There are a few different levels of validation needed, for different parts
of the codebase:

* Core functionality that manages the communication channels and routes
  messages for further processing only needs to care that the basic message
  structure is correct and that the routing information is sufficiently
  validated to correctly route the messages.
* Game servers and clients need to deeply validate the messages they receive
  (and possibly the ones they send, to reduce the likelihood of game engine
  bugs resulting in sending corrupted messages).
* UI plugins should be able to assume that clients have done the core semantic
  validation, and can focus on ensuring the data has been defanged for safe
  display in that particular display (escaping HTML in strings, preventing
  writes outside the active viewport, etc.).


# Standards

Expected standards for each of the communicating layers:


## Server App

* Server configuration makes sense
* Universe configuration makes sense
* Connection and authentication attempts are non-abusive
* Overload is shed properly


## Server Storage

* Foreign key relationships hold
* Storage-side semantic rules are checked and enforced
* Identities are syntactically valid
* Identities are universe-unique even after de-confusion


## Server Session

* Network messages can be parsed into MUGS::Message objects
* Messages can be routed to proper game or global server task
* No non-validated data is used in routing operations


## Server Game

* All consumed fields syntactically validated
* All consumed fields semantically validated
* All consumed fields statefully validated where appropriate


## Client Session

* Network messages can be parsed into MUGS::Message objects
* Messages can be routed to proper game or lobby task
* No non-validated data is used in routing operations


## Client Game

* All consumed fields syntactically validated
* All consumed fields semantically validated
* All transmitted fields semantically validated


## UI App

* All data defanged as appropriate for the UI type


## UI Game

* All data cleaned/canonified for safe display
