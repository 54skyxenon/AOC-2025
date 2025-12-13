# Advent of Code 2025

I'm back for AoC 2025, this time in Perl!

## Reflections

I'm not a fan of how every type is context-dependent in Perl and I probably won't use it again personally/professionally. I will note that one strength Perl has is parsing text files well though.

I struggled the most with:
- Day 9 (Part 2)
- Day 12

## Input
All input is read from TXT files under the `inputs/` folder that you need to make prior to executing any code.

## Environment Details
My Perl version:
```bash
$ perl --version

This is perl 5, version 34, subversion 1 (v5.34.1) built for darwin-thread-multi-2level
(with 2 registered patches, see perl -V for more detail)

Copyright 1987-2022, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

To execute a specific Perl file I do:
```bash
$ perl hello.pl
Hello, World!
```

I also have [glpk](https://www.gnu.org/software/glpk/) installed for some days needing it:
```
brew install glpk
```