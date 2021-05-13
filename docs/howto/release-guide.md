% Release Guide

*Reviewed 2021-04-15 by japhb*

**NOTE: This Release Guide represents current partially-automated state as of
        version 0.1.1; further automation is planned in future releases.**


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

#. Look for trouble:
   #. Search for and address or file as an issue any XXXX, WIP, NYI, TODO, etc. comments
   #. Check that all GitHub "blocker" issues have been addressed
   #. Run performance tests and check for regressions
   #. Check for uncommitted changes
#. Update Changes file with important changes and commit
#. Update Changes with next version and current date
#. `export NEXT_MUGS_VERSION=A.B.C`
#. Until clean, repeat:
   #. `mugs-release check --version=$NEXT_MUGS_VERSION`
   #. Fix any problems found and commit


# Release

For each repo **in sequence**:

#. Update dependencies
   #. Update `depends` versions in META6
   #. Update `t/00-use.rakutest` for versioned prereqs
   #. Rerun tests to check prereq update didn't break anything
   #. `git commit -m "Release prep: Update versioned dependencies" META6.json t/00-use.rakutest`
#. Update version
   #. Update base module version
   #. Run `mi6 build` to transfer to META6
   #. `git commit -m "Release prep: Update version to $NEXT_MUGS_VERSION" Changes META6.json lib/MUGS/...`
#. Final check; then tag, push, and upload release
   #. `mugs-release check --version=$NEXT_MUGS_VERSION`
   #. `mugs-release --version=$NEXT_MUGS_VERSION --/codename`
      (or `--codename="Codename"` if release has a codename)


# Post-Release

#. Install entirety of MUGS on a clean system/VM/container
#. Perform acceptance tests
#. Update #mugs topic
#. Announce in #mugs and #raku
