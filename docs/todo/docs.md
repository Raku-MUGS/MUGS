% Documentation TODOs

*Reviewed 2021-03-03 by japhb*


When your brain is done with code, how about documenting something?  :-)


* Getting Started
  * ... as a user
  * ... as a contributor
* Bring diagrams up to date with latest code/designs
  * message-flow.dot
* Bring design docs up to date with latest implementation
  * Mark sections that are NYI for clarity
  * Mark all DDs with latest review date
* Coding Standards
  * Exception rules: X::MUGS, required attributes, thin factoring, etc.
  * Standard phases for entities with a lifecycle
  * Use of lexical constants
  * OO v. exported subs
* CLI I/O conventions
  * Highlighted prompts
  * Empty input just tries prompt again
  * ^C breaks out of current request/flow
  * Input lines trimmed at start and end
  * /commands for meta control
  * help|? [topic] for getting general, contextual, or topical help
