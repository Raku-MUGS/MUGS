% Game State


Ruminations on game state that must be kept.


# Transfers to Clients

## Before Game Creation

* Game type
* Game description
* Config form
* Genre tags
* Content tags


## At Game Creation

* Game ID
* Game seed?
* Leader server?
* Game config, filtered for creator


## When Browsing

* (Don't show game if full or invite-only)
* Game type
* Game description
* Game name
* Genre tags
* Content tags
* Game config, filtered for non-participants


## When Joining

* Game creator
* Game name
* Game config, filtered for participants
* Invite-only status
* Game-full status
* Team names
* Team participants (if visible)
* Game state
* Game time
* Game phase
* WinLoss state(s)
* Game state needed to allow first action


## On Own Action

* Game state
* Game time
* Game phase
* WinLoss state(s)
* Turn state if turn-based
* Global game status changes
* Player-visible state changes


## On Other Player Action

* Game state
* Game time
* Game phase
* WinLoss state(s)
* Turn state if turn-based
* Participant changes visible to me
* Other state changes visible to me


# State Types

## Static Info

* Game type
* Implementation class
* Valid action types
* Game description
* Config form
* Genre tags
* Content tags


## All Games

* Game ID
* Leader server
* Game creator
* Game name
* Game config
* Invite-only status
* Game-full status
* Game state
* Game time
* Game phase
* Participants
  * Characters
  * Instances
  * Sessions
* Request queue
* Event stream
* Action stream


## Genre and Game Type Specific

* Globally visible game state
  * Game seed?
* Fully hidden game state
  * RNG states?
* Per-player self-visible state
* Per-player others-visible state


## Location-Based Games

* Map layers
* Entity locations
* Per-location state
  * Discoverable
  * Fully visible
  * Fully hidden
* Per-entity state
  * Discoverable
  * Fully visible
  * Fully hidden
* Per-player beliefs
  * About locations
  * About entities
  * About other players
  * Timestamp of when belief was created or last verified?


## Single Player or Co-op Games

* Game WinLoss state


## Competitive Games

* Player or team WinLoss state


## Team Games

* Team names
* Team composition
* Per-player team-visible state


## Turn-Based Games

* Turn count
* Turn phase
* Play order (where index 0 = start player?)
* Current player
* Next player
