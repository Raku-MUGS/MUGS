% Release Guide

*Reviewed 2021-03-10 by japhb*

**NOTE: This Release Guide is in a DRAFT state, and has not yet been used to
        run a complete release cycle.**


# Major Releases

#. For every genre and game:
   #. Test Client/Server pairs
   #. Check Assistive Technology support
   #. Check that each is supported in at least 2 UIs
#. Review all docs, update any bitrotted sections, and update review mark at top
#. Check that all [Release Roadmap](../todo/release-roadmap.md) todo items for
   this release have been addressed or deferred


# Pre-Flight Checklist

For each repo:

#. Search for and address or file as an issue any XXXX, WIP, NYI, TODO, etc. comments
#. Run tests and fix if any broken
#. Run performance tests and check for regressions
#. Check that all GitHub "blocker" issues have been addressed
#. Check for uncommitted changes
#. `fez checkbuild` and address any errors
#. `git push` if needed
#. Update Changes file with important changes and commit
#. `export NEXT_MUGS_VERSION=A.B.C`


# Release

For each repo **in sequence**:

#. Run tests and fix if any broken
#. Update dependencies
   #. Update `depends` versions in META6
   #. Update `t/00-use.rakutest` for versioned prereqs
   #. Rerun tests to check prereq update didn't break anything
   #. `git commit -m "Release prep: Update versioned dependencies" META6.json t/00-use.rakutest`
#. Update version
   #. Update base module version
   #. Run `mi6 build` to transfer to META6
   #. Update version and date in Changes
   #. `git commit -m "Release prep: Update version to $NEXT_MUGS_VERSION" Changes META6.json lib/MUGS/...`
#. Tag release
   #. `git tag -a v$NEXT_MUGS_VERSION -m "Release $NEXT_MUGS_VERSION"`
   #. `git tag -a "<codename>" -m "Codename <codename>"`
      if release has a codename
   #. `git push`
   #. `git push --tags`
#. `zef install .`
#. `fez upload`


# Post-Release

#. Install entirety of MUGS on a clean system/VM/container
#. Perform acceptance tests
#. Update #mugs topic
#. Announce in #mugs and #raku
