[![Actions Status](https://github.com/Raku-MUGS/MUGS/workflows/test/badge.svg)](https://github.com/Raku-MUGS/MUGS/actions)

NAME
====

MUGS (Multi-User Gaming Services) - A Raku-based platform for game service development

SYNOPSIS
========

    ### INITIAL SETUP

    # Install MUGS (expect precompilation to take a while)
    zef install MUGS

    # Create a long-lived (on disk) data set and identity universe
    mugs-admin create-universe [<universe-name>]  # Defaults to "default"


    ### LOCAL CLIENTS

    # Play games using a local UI, using an internal stub server and ephemeral data
    mugs-cli  # Turn-based CLI

    # Play games using an internal stub server accessing the long-lived data set
    mugs-cli --universe=<universe-name>

    # Log in and play games on a WebSocket server using a local UI
    mugs-cli --server=<host>:<port>


    ### GAME SERVERS

    # Start a TLS WebSocket game server on localhost:10000 using fake certs
    mugs-ws-server

    # Specify a different MUGS identity universe (defaults to "default")
    mugs-ws-server --universe=other-universe

    # Start a TLS WebSocket game server on different host:port
    mugs-ws-server --host=<hostname> --port=<portnumber>

    # Start a TLS WebSocket game server using custom certs
    mugs-ws-server --private-key-file=<path> --certificate-file=<path>

    # Write a Log::Timeline JSON log for the WebSocket server
    LOG_TIMELINE_JSON_LINES=log/mugs-ws-server mugs-ws-server


    ### WEB UI GATEWAYS

    # Start a web UI gateway on localhost:20000 to play games in a web browser
    mugs-web-simple --server-host=<websocket-host> --server-port=<websocket-port>
    mugs-web-simple --server=<websocket-host>:<websocket-port>

    # Start a web UI gateway on a different host:port
    mugs-web-simple --host=<hostname> --port=<portnumber>

    # Use a different CA to authenticate the WebSocket server's certificates
    mugs-web-simple --server-ca-file=<path>

    # Use custom certs for the web UI gateway itself
    mugs-web-simple --private-key-file=<path> --certificate-file=<path>

    # Turn off TLS to the web browser (serving only unencrypted HTTP)
    mugs-web-simple --/secure

DESCRIPTION
===========

MUGS is a set of basic services written in the Raku language for creating client-server and multi-user games. It abstracts away the boilerplate of managing player identities, tracking active games and sessions, sending and receiving messages and actions, and so forth.

This Proof-of-Concept release includes a simple local CLI UI, a WebSocket-based game server, a Web UI gateway, and simple admin and developer tools. It can store data using either an internal ephemeral/test storage driver, or in SQLite databases on disk using a storage driver based on the Red ORM.

This release also includes a small selection of very simple games to exercise the basic infrastructure and services.

ROADMAP
=======

MUGS is still in its infancy, at the beginning of a long and hopefully very enjoyable journey. There is a [draft roadmap for the first few major releases](docs/todo/release-roadmap.md) but I don't plan to do it all myself -- I'm looking for contributions of all sorts to help make it a reality.

CONTRIBUTING
============

Please do! :-)

In all seriousness, check out the [CONTRIBUTING doc](docs/CONTRIBUTING.md) (identical in each repo) for details on how to contribute, as well as the [Coding Standards doc](docs/design/coding-standards.md) for guidelines/standards/rules that apply to code contributions in particular.

The MUGS project has a matching GitHub org, [Raku-MUGS](https://github.com/Raku-MUGS), where you will find all related repositories and issue trackers, as well as formal meta-discussion.

More informal discussion can be found on IRC in [Freenode #mugs](ircs://chat.freenode.net:6697/mugs).

AUTHOR
======

Geoffrey Broadwell <gjb@sonic.net> (japhb on GitHub and Freenode)

COPYRIGHT AND LICENSE
=====================

Copyright 2021 Geoffrey Broadwell

MUGS is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

