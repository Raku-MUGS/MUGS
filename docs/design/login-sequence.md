% Login Sequence

*Reviewed 2021-03-03 by japhb*

**NOTE: NYI AND LARGELY ASSUMES SPLIT SERVER TYPES IS IMPLEMENTED**


# Notes

* RTT in a single strand of glass fiber to the other side of the earth would be ~200ms.
* (TLS SETUP = DNS + 2 RTT) is the setup time for a new TCP-based TLS 1.3 connection.


# Login Steps

1. (TLS SETUP) Connect to Login Server
2. (1 RTT) Send username, credentials, and supported protocol versions
   * If protocol version not supported, indicate error and shut down connection
   * Unless username/credentials validated, return auth failure and repeat
   * Otherwise return auth success and optionally a redirect location with
     an opaque single-use expiring login ticket
3. (TLS SETUP) If redirected, drop Login Server connection and connect
   to redirect location using ticket
4. (1 RTT) Request server/user welcome info bundle
   * Return all of:
     * General info about server
     * Upgrade hint if server supports newer protocols
     * Welcome message, house rules, etc., if any
     * Authorized personas and their characters, marking user's defaults
     * Permitted (and supported) game types for that user
     * Server-wide game stats: count active, count full, count filling, etc.
     * Games that user's authorized personas/characters are currently in
   * Note: These should all be available to request individually as well
5. **User choice:** Select existing identities, Create new identities, Stay incognito
6. (1 RTT) Request desired identities
   * If not permitted, return failure; client should request authorized
     personas and characters again (1 RTT) and return to step 5
7. **User choice:** Create a game, Join a game, ...
