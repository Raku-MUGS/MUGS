% Chain of Identity Rights

*Reviewed 2021-03-03 by japhb*

**NOTE: THIS DESIGN IS NYI (NOT YET IMPLEMENTED) EXCEPT FOR MINOR PREREQ WORK**


# Administrator Rights

Rather than a single root-like superadmin account, MUGS uses a finer-grained
admin rights system.  A key feature of this system is that users do not hold
ambient admin rights; trusted users merely have the right to *request* higher
rights when needed, as if using `sudo`, and only within a particular scope.
There exists a `REQUEST_FOO_ADMIN` grant in each appropriate scope for every
`FOO_ADMIN` right, and even the most powerful users only carry these `REQUEST`
grants normally.

For example, a root-like user would be granted `REQUEST_*_ADMIN` for all key
`*_ADMIN` variants, but a user trusted only with account repair work would
instead be granted only `REQUEST_IDENTITY_ADMIN` in the identity DB.


## Universes and the Admin Bootstrap

The largest scope of admin rights is a single identity namespace, known as a
MUGS "universe".  A new universe is created with a single account, whose owner
is granted `REQUEST_META_ADMIN` for that universe.  From that point on, only
users holding `META_ADMIN` can create widely-scoped admins of any type.

Likewise, only users holding `SINGLE_ACCOUNT_META_ADMIN` for a given account
(which by default only the account owner can request) can define new
narrowly-scoped admins in that account.

Finally, game creators are given default grants allowing them control of the
games they have created, but the exact set depends on the universe config and
any restrictions or rights that the game creating user had.


## Admin Variants

The base widely-scoped admin rights are as follows:

`META_ADMIN`
  : Can grant `REQUEST_*_ADMIN` for any widely-scoped admin right in a given
    universe.  To prevent `DB_ADMIN` or `SERVER_ADMIN` from effectively having
    `META_ADMIN`, the list of meta-admins is kept in the universe config --
    outside the universe identity database and read-only to all server types.

`DB_ADMIN`
  : Full rights to change anything in a particular database, and thus total
    power over persisted state.  Can perform low-level database repair and
    maintenance.

`IDENTITY_ADMIN`
  : Full rights to create or make modifications to any identity information in a
    particular identity database, including accounts, users, user credentials,
    user grants, personas, characters, etc.

`SERVER_ADMIN`
  : Full rights to change anything about a particular server's configuration or
    server-global state; ability to kick sessions, add users and endpoints to
    deny or allow lists; etc.

`GAME_ADMIN`
  : Full rights to create, delete, and control the configuration and state of
    any game known to a particular server.

There are also narrowly-scoped admin rights, held by individual account owners
over their own account, game creators over games they created, and so on:

`SINGLE_ACCOUNT_META_ADMIN`
  : Rights to manage an individual account, its admins, and its identity info.

`SINGLE_PERSONA_ADMIN`
  : Rights to manage an individual persona and its characters.

`SINGLE_GAME_ADMIN`
  : Rights to manage a game owned (and usually created) by that user.

See Identity Rules below for more details on these narrowly-scoped admin rights.


# Server Types

MUGS servers need not be a single monolithic binary; they can be split into
smaller, more focused services for security (minimizing attack surface and
potential damage if subverted) or scalability reasons.

The following assumes a full defense-in-depth, least-rights deployment.  All
log types are only writeable by server types that explicitly list them.


## Login Server

Trusts:

* NOTHING ELSE

Can:

* Read and locally enforce anti-abuse configuration
* Read identity and credential info sufficient for minimal login
* Grant an expiring verifiable login ticket
* XXXX: Redirect logged in user to appropriate Account Server?
* Append to login logs

CANNOT:

* Read or write *any* other info


## Account Server

Trusts:

* Valid Login Server tickets

Can:

* Create account/account-owner pairs
* Read and write identity and credential info according to Identity Rules
* Append to identity and credential logs

CANNOT:

* Read or write any game data/metadata


## Game Admin Server

Trusts:

* Valid Login Server tickets

Can:

* Read identity info
* Create, administer, and end games
* Assign games to Game Play Servers
* Read and write game metadata
* XXXX: Direct joining users to correct Game Play Server?
* Append to game admin logs

CANNOT:

* Read credential info
* Write to any identity info


## Game Play Server

Trusts:

* Valid Login Server tickets
* Game Admin Server

Can:

* Read identity info (XXXX: Limit this?)
* Serve games assigned to the server
* Read game metadata for assigned games
* Read and write game data for assigned games
* Append to game play logs for assigned games

CANNOT:

* Read credential info
* Read data or metadata for unassigned games
* Write to any other types of data or metadata


# Identity Rules

Account owners can:

* Act as an admin for that account
* Designate other users in the account as owners or admins
* Revoke owner or admin status of other users in the account

Account admins can:

* Set/reset credentials for users in that account
* Create additional users in that account
* Create personas in that account

Players with valid user credentials can:

* Log on as that user
* Add/change credentials for that user

Persona creators can:

* Add authorized users from their account to that persona
* Create and modify characters for that persona

Authorized persona users can:

* Select that persona
* Select any character in that persona

Characters can:

* Join, play, and leave games
