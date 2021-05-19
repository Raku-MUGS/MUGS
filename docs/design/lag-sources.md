# Sources of Lag/Latency


This doc is a rumination on sources of lag/latency in a client/server twitch
game, each of which may not be perceptible on its own, but together can make
the game feel sluggish, laggy, jerky, or generally high-latency.


# Delay Timeline

The following is a sample timeline, based on the player's screen displaying an
event that the player will need to react to at time 0:


| Time        | Process                                                                   |
|:------------|:--------------------------------------------------------------------------|
| 0           | Output devices present initial stimulus (display, sound, vibration, etc.) |
| react       | Player's sensory and motor systems process the event; the player reacts   |
| controller  | Player's reaction input is read by the input device(s), OS, and game engine |
| command     | Input is processed by game engine and converted to game commands |
| to-server   | Game commands are transmitted to the server |
| process     | Game commands are parsed and processed by server |
| simulate    | Server incorporates commands into next simulation step |
| update      | Server wraps simulation results into update to send |
| to-client   | Game update is transmitted to client |
| incorporate | Game update is incorporated as source of truth in client |
| predict     | Game client predicts next frame's world state |
| render      | Next frame's state is rendered in graphics/sound/haptic/etc. |
| buffer      | Game output is buffered by output devices |
| output      | Game output is actually presented to user |

That's a LOT of accumulated delay, though the contribution from each varies
considerably not just across processes but for a single process under different
conditions.


# Delay Estimates

The following sections estimate typical delays for each process in the timeline:


## React

Typical human response times depend on a great many factors -- type of sensory
input, previous warning signals, mental attention level, dopamine levels in the
brain, number of response choices, number of possible inputs, amount of mental
processing and cross-brain coordination required, synchronization with
background cycles such as finger twitching, etc.  However, some general
guidelines give a rough idea:

* 100ms -- Approximate lower bound for a true reaction (not anticipated/predicted)
* 160ms -- Average college-student *simple* RT for auditory inputs
* 190ms -- Average college-student *simple* RT for visual inputs
* 200ms -- Typical *simple* RT for average human
* 300-500ms -- Typical RTs for more complex tasks


## Controller

Controllers generally have an internal sampling rate, external polling rate,
transmission time via wire or Bluetooth, host/driver/OS delays, etc.  Here are
some common measured totals:

* 3-13ms mean, 2-4ms σ -- Dedicated game controllers
* 5-40ms mean, 1-5ms σ -- Mouse buttons

Note that poorly designed or configured controllers can be much worse.  For
instance, a few dedicated game controllers have ~24ms of delay.

For wireless receivers, controller delay includes wireless receiver polling
delay (on my system, 8ms for keyboards and 2ms for mice).


## Command

The game engine must pick up inputs in order to compute a command packet to
send to the server.  This happens only every game engine input sampling period.
Some game engines lock this to the frame rendering period in order to improve
stability of perceived lag; others sample on a separate fixed timer in order
to keep everyone's input sampling approximately equal (and in a range optimal
for other parts of the game engine design).  Expected contributions:

* .5 (mean) - 1 (max) sample period -- Delay between controller signal and game processing start
* <1ms -- Conversion of inputs to command packet


## To Server

This includes the time to serialize the command packet, plus network
transmission time (depending on packet size and lowest link bandwidth), plus
base network latency (dependent on distance, network types, network hops,
etc.).  Typical values:

* <1ms -- Serialization of packet
* 1-10ms -- Transmission time
* 10-200ms -- Network latency


## Process

Once the server receives the complete command packet (which may involve queuing
of incoming packets), it must deserialize it, validate it, and prepare it as a
simulation input.

* <1ms -- Deseralization/validation of command packet


## Simulate

Commands that arrive while a simulation step is already occurring typically
have to wait for the next simulation step to begin.  Choosing the simulation
interval is typically a tradeoff of delay, resource usage, and accuracy.

* .5 (mean) - 1 (max) simulation period -- Wait for next simulation step
* 10-100ms -- Typical simulation period (15-50ms especially common)


## Update

Some servers send one update per simulation step; others perform several sim
steps per update round, or adapt update rate to client performance/bandwidth.
Thus the latency due to this stage depends heavily on server engine design.

* 1-100ms -- Typical update delay


## To Client

Sending an update to the client is essentially a mirror of the [To
Server](#to-server) situation, except that updates from the server are almost
always larger (sometimes considerably larger) than command packets, and they
often must queue because the server is sending updates to every client instead
of just one server.  Thus the serialization and transmission times can be
significantly larger:

* 1-5ms -- Serialization of packet
* 2-50ms -- Transmission time
* N*transmit -- Queuing delay for N other players getting updated
* 10-200ms -- Network latency


## Incorporate

The new update must be incorporated as a source of truth for the client
simulation, including validation and discrepancy detection.

* 1-5ms -- Deserialization/validation of command packet
* 1ms -- Discrepancy detection against client predictions


## Predict

Just like the server, the client usually runs a simulation of the game world
(at least, the part visible to the player), and updates could arrive at any
time during a simulation period.  Unlike the server's simulation, the client's
simulation is based on prediction (either interpolation or extrapolation), and
has the simpler task of simply predicting what the player's next output render
should be based on.

* .5 (mean) - 1 (max) simulation period -- Wait for next simulation step
* 0-4 simulation periods -- Interpolation lag and lost packet compensation
* 10-50ms -- Typical prediction periods


## Render

The engine must wait for command buffers to be available to record rendering
commands.  In some systems this will be essentially instantaneous (with a queue
of pre-allocated command buffers), while others may require waiting for a
previous render to finish and free up resources.  Once those are available, it
must fill the command buffers and request render (on a GPU or APU, for
instance).  If the render requires host-based post-processing, the game engine
may have to wait for the render to complete and read the results back to the
CPU memory, and repeat the cycle to finally get the post-processed result back
in the output buffers.

* 0-1 frame times -- Wait for free command buffers
* 0-1 frame times -- Fill command buffers
* 0-1 frame times -- Wait for render slot
* 0-1 frame times -- Render output
* 0-1 frame times -- Post-process delay
* 16.7 or 33.3ms -- 60Hz or 30Hz frame time (typical video output)
* 5-30ms -- Typical low-latency audio output


## Buffer

Rendering hardware and output devices will both typically buffer the output
stream, delaying the time of actual output to the user:

* 0-1 frame times -- Rendering hardware buffer
* 0-2 frame times -- Output device hardware buffer


## Output

And finally other players can see the server response to the first player's
action (or the first player can see the server correction of a misprediction).

**NOT** including human reaction time, thus counting only from controller input
to response output, and even with fast simulation and polling intervals of just
8ms, the total delay will be at least 50ms + RTT, and more likely in the range
of 100ms + RTT or more.


# For Comparison

Different game genres have different latency requirements and expectations.
For example, local console/arcade fighting games are typically locked at 60 Hz,
and are considered to have good overall game latency if the lag from user input
(the moment a controller button is pressed) to output response is ~2.5 frame
times or ~42 ms.  On the opposite end, in turn-based gameplay -- as long as
there is some indication that an action has been *started* so as to avoid
tendency to retry -- latency of 1-2 seconds to complete the action is normally
acceptable.

Here are some human latency perceptual numbers for comparison:

* 5-15ms -- Sound source appears to move
* 5-50ms -- Latency differences just distinguishable in direct tasks
* 10-15ms -- Visual processing begins
* 40-50ms -- Light flashes perceptually separate
* 40-75ms -- Tracking/following skills degraded
* 50-80ms -- Audio is felt as beats rather than heard as a tone
* 50-100ms -- Latency differences just distinguishable in **in**direct tasks
* 85-100ms -- Delay becomes consciously noticed
* 300-350ms -- Eyes shift gaze/focus
* 200-2000ms -- Tendency to retry actions
