% Game Classes

*Reviewed 2021-05-12 by japhb*


The charts below show the inheritance relationships of the Client, Server, and
UI genre and game implementation classes.  Note that it is **NOT** necessary to
use the same inheritance hierarchy at all tiers -- there will likely be
different abstractions to be factored out -- though keeping the hierarchies
roughly similar (except for maybe a little flatter in places) tends to reduce
confusion.


# MUGS::Server::

```
# In MUGS-Core
Game
├── Game::Lobby
├── Genre::Test
│   ├── Game::Echo
│   └── Game::Error
│
│   # In MUGS-Games
├── ((Genre::Test))
│   └── Game::PFX
└── Genre::TurnBased
    ├── Genre::BoardGame
    │   └── Genre::RectangularBoard
    │       └── Genre::MNKGame
    │           └── Game::TicTacToe
    ├── Genre::CardGame
    ├── Genre::Guessing
    │   ├── Game::NumberGuess
    │   └── Game::Snowman
    └── Genre::IF
        └── Game::Adventure
```


# MUGS::Client::

```
# In MUGS-Core
Game
├── Game::Lobby
├── Genre::Test
│   ├── Game::Echo
│   └── Game::Error
│
│   # In MUGS-Games
├── ((Genre::Test))
│   └── Game::PFX
└── Genre::TurnBased
    ├── Genre::BoardGame
    │   └── Genre::MNKGame
    │       └── Game::TicTacToe
    ├── Genre::CardGame
    ├── Genre::Guessing
    │   ├── Game::NumberGuess
    │   └── Game::Snowman
    └── Genre::IF
        └── Game::Adventure
```


# MUGS::UI::CLI::

```
# In MUGS-Core
MUGS::UI::Game
│
│   # In MUGS-UI-CLI
└── Game
    ├── Game::Lobby
    ├── Genre::Test
    │   └── Game::Echo
    ├── Genre::BoardGame
    │   └── Genre::MNKGame
    │       └── Game::TicTacToe
    ├── Genre::Guessing
    │   ├── Game::NumberGuess
    │   └── Game::Snowman
    └── Genre::IF
        └── Game::Adventure
```


# MUGS::UI::TUI::

```
# In MUGS-Core
MUGS::UI::Game
│
│   # In MUGS-UI-TUI
└── Game
    └── Game::PFX
```


# MUGS::UI::WebSimple::

```
# In MUGS-Core
MUGS::UI::Game
│
│   # In MUGS-UI-WebSimple
└── Game
    ├── Genre::Test
    │   └── Game::Echo
    ├── Genre::Guessing
    │   ├── Game::NumberGuess
    │   └── Game::Snowman
    └── Genre::IF
        └── Game::Adventure
```
