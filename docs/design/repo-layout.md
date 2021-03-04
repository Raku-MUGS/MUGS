% MUGS Repository Layout

*Reviewed 2021-03-04 by japhb*


# [Raku-MUGS Repos](https://github.com/Raku-MUGS)

[MUGS-Core](https://github.com/Raku-MUGS/MUGS-Core)
  : Core modules

[MUGS-Games](https://github.com/Raku-MUGS/MUGS-Games)
  : Free-as-in-speech game implementations

[MUGS-UI-CLI](https://github.com/Raku-MUGS/MUGS-UI-CLI)
  : CLI UI, including App and game UIs

[MUGS-UI-WebSimple](https://github.com/Raku-MUGS/MUGS-UI-WebSimple)
  : WebSimple UI, including HTTP gateway and game UIs

[MUGS](https://github.com/Raku-MUGS/MUGS)
  : Root repo; includes docs and depends on all other released repos


# General Layout of All Repos

Not all repos will contain all directories listed below, but what directories
they do have will match the following general layout:

```
.
├─ bin             # Small launch wrappers for MUGS::App::* apps
├─ doc
│  ├─ design       # Design docs
│  └─ todo         # Open todos
├─ lib
│  └─ MUGS
│     ├─ App       # Launchable apps (client, server, or admin/util/tool)
│     ├─ Client    # *Non-UI* portions of client code
│     ├─ Server    # Server code
│     ├─ UI        # User interfaces (sharing common Client code above)
│     └─ Util      # Utility modules
│
├─ resources       # Read-only (non-code) resources
└─ t               # Tests

```


# Detailed Views

## MUGS-Core

```
.
├── bin                        # mugs-admin, mugs-tool, mugs-ws-server
│
├── docs                       # CONTRIBUTING.md (see MUGS repo for others)
│
├── lib
│   └── MUGS                   # Common base modules
│       │
│       ├── App                # App modules for bin/ + LocalUI base for UI Apps
│       │
│       ├── Client             # *Non-UI* portions of client code
│       │   ├── Connection     # Communication channels to servers
│       │   ├── Game           # Client-side logic for Echo and Lobby
│       │   └── Genre          # Shared client code for Test genre
│       │
│       ├── Server             # Server code
│       │   ├── Connection     # Communication channels with clients
│       │   ├── Game           # Server-side logic for Echo and Lobby
│       │   ├── Genre          # Shared server code for Test genre
│       │   └── Storage        # Server-side persistent storage
│       │       └── Driver     # Storage drivers: Red::SQLite + Fake (in-memory)
│       │
│       └── Util               # Utility modules
│
├── resources                  # Read-only (non-code) resources
│   ├── conf                   # Configuration defaults
│   └── fake-tls               # Fake TLS certs for local testing
│
└── t                          # Tests

```


## MUGS-Games

```
.
├── docs                       # CONTRIBUTING.md (see MUGS repo for others)
│
├── lib
│   └── MUGS
│       ├── Client
│       │   ├── Game           # Client-side per-game-type logic
│       │   └── Genre          # Shared client code for common game genres
│       └── Server
│           ├── Game           # Server-side per-game-type logic
│           │   └── Adventure  # Extra support modules for Adventure game
│           └── Genre          # Shared server code for common game genres
│
├── resources
│   └── game                   # Game-specific resource files
│       └── adventure          # Adventure scenarios
│           └── new-path       # 'new-path' scenario
│
└── t                          # Tests

```


## MUGS-UI-CLI

```
.
├── bin                        # mugs-cli
│
├── docs                       # CONTRIBUTING.md (see MUGS repo for others)
│
├── lib
│   └── MUGS
│       ├── App                # App module for mugs-cli
│       └── UI                 # MUGS::UI::CLI plain text interface base module
│           └── CLI            # Line-editing input driver
│               ├── Game       # Game type specific CLI interfaces
│               └── Genre      # Shared CLI code for common game genres
│
└── t                          # Tests

```


## MUGS-UI-WebSimple

```
.
├── bin                        # mugs-web-simple
│
├── css                        # Common CSS files
│
├── docs                       # CONTRIBUTING.md (see MUGS repo for others)
│
├── lib
│   └── MUGS
│       ├── App                # App modules for mugs-web-simple
│       │   └── WebSimple
│       └── UI
│           └── WebSimple
│               ├── Game       # Game type specific WebSimple interfaces
│               └── Genre      # Shared WebSimple code for common game genres
│
├── resources
│   └── fake-tls               # Fake TLS certs for local testing
│
├── t                          # Tests
│
└── templates                  # HTML templates

```


## MUGS

```
.
├── docs                       # CONTRIBUTING.md
│   ├── design                 # Design docs, diagrams, and ruminations
│   └── todo                   # Open todos
│
├── lib                        # MUGS module (used to build README)
│
└── t                          # Tests

```
