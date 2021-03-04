% MUGS Repository Layout


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


# General Layout of Each Repo

Not all repos will contain all directories listed below.

```
.
├─ bin                  # Small launch wrappers for MUGS::App::* apps
├─ doc
│  ├─ design            # Design docs
│  └─ todo              # Open todos
├─ lib
│  └─ MUGS
│     ├─ App            # Launchable apps (client, server, or admin/util/tool)
│     ├─ Client         # *Non-UI* portions of client code
│     ├─ Server         # Server code
│     ├─ UI             # User interfaces (sharing common Client code above)
│     └─ Util           # Utility modules
│
├─ resources            # Read-only (non-code) resources
└─ t                    # Tests

```
