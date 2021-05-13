% Supporting "Bullet Hell" Games

*Reviewed 2021-05-12 by japhb*


# Problem Statement

[Bullet Hell](https://tvtropes.org/pmwiki/pmwiki.php/Main/BulletHell) games
present a particularly interesting performance puzzle.  There may be hundreds
or even thousands of objects (mostly projectiles and beams) on the screen and
moving at the same time, some of which can change direction, spawn other
objects, or otherwise act in non-trivial ways.  At the same time it is expected
that the world update rate for such games is relatively high, so in even
moderate cases it may be necessary to support updates of hundreds of objects
dozens of times per second each.

Given the number of state variables per object, object count, and update rate,
without some form of data optimization the total number of variable updates per
second during peak play would rapidly reach into the hundreds of thousands.
This isn't going to work all that well over a network transport that's
trivially serializing the entire visible state into JSON every tick.


# Approaches

There are few ways to get some improvement here without extreme effort:

* Serialize to a binary (or binary-pretending-to-be-text) encoding
  * **UPDATE: Done; switched serialization to CBOR via `CBOR::Simple` and `Cro::CBOR`**
* Separate updates by complexity
  * Trivial, such as "continue previous trajectory" or "expire"
  * Minor updates, "turn" or "change speed"
  * Full updates
  * New object spawns
* RLE trivial and minor updates
* Sort together (and factor out) common state across objects


# MTU

In determining how much more optimization needs to be done, one useful data
point is the available remainder of the PMTU (Path Maximum Transmission Unit),
the largest amount of data that can be sent in a single packet without
fragmentation in the network.  Packets are the network unit of loss and
retransmission, and having a single chunk of application data split over extra
packets substantially increases the risk of loss and various delays.

Classic Ethernet frames are the de facto standard for network transmission, and
a (non-handshake) frame can be broken down in layers as follows:

|Layer      |Overhead|Remainder|Notes                                     |
|:----------|-------:|--------:|:-----------------------------------------|
|<Raw>      |        |     1542|Raw octets + signaling/spacing on the wire|
|ENet Layer1|      20|     1522|                                          |
|ENet Layer2|      22|     1500|Standard "MTU"                            |
|IPv6       |      40|     1460|IPv4 is 20 + options                      |
|TCP        |      20|     1440|                                          |
|TCP Time   |      10|     1430|TCP Timestamps option is standard on Linux|
|TCP NOP Pad|       2|     1428|TCP options length must be a multiple of 4|
|TLS 1.3    |       6|     1422|5 (fake TLS 1.2 header) + 1 (record type) |
|TLS AuthTag|      16|     1406|AEAD -- Replaces classical record MAC     |
|WebSocket  |       4|     1402|2 (base) + 2 (16-bit data size)           |
|WS Mask Key|       4|     1398|Only in client --> server direction       |

Additional encapsulation or tunneling will reduce that further; for example
MPLS routing may add another 12 bytes of overhead and reduce the remainder
accordingly.  Other encapsulation methods are even heavier.

In short, under the 2021-current assumption of sending data bidirectionally via
WebSocket over TLS 1.3 over IPv6 we can expect around 1400 bytes available per
packet for the actual encoded data in the steady state (once handshaking
completes for all the various protocols), less if any tunneling is going on.


# Variables

Even in relatively simple cases, we'll need to track at least the following for
each object:

* Object type
* 2D position
* 2D velocity

For objects that are more complex than unchanging fixed-size circles, we'll
also need some or all of the following:

* 2D acceleration
* Z-sort
* Rotation/facing
* Rotational velocity
* Rotational acceleration
* Animation state
* Size
* Age


# Update Metadata

Data included with every update:

* GameID
* Game time
* Game state (e.g. paused)

For transports that bucket different types of object changes:

* # spawned this update
* # updated this update
* # expired this update


# Transport Efficiency

*Transports:*

* Raw   -- 32 bits per variable, all variables every time
* 16bit -- Shrink to 16 bits per variable, all variables
* 8bit  -- Shrink to  8 bits per variable, all variables
* 2x16  -- Shrink to 16 bits per variable, only 2 variables per object per update
* Bins  -- 1/5 of objects in each bin: 0..4 16-bit variables per object per update

*Transport data rates in kbps (k=1000), ignoring overhead:*

|Scenario|Vars|Count|Freq|Raw Updates| Raw |16bit|8bit|2x16|Bins|
|:-------|---:|----:|---:|----------:|----:|----:|---:|---:|---:|
|Trivial |   5|   10|10/s|      500/s|   16|    8|   4|   3|   3|
|Simple  |   5|  100|10/s|     5000/s|  160|   80|  40|  32|  32|
|Moderate|  10|  250|20/s|    50000/s| 1600|  800| 400| 160| 160|
|Heavy   |  10| 1000|50/s|   500000/s|16000| 8000|4000|1600|1600|
