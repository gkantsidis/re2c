# re2c under Windows

The goal is to be able to compile `re2c` using the Visual Studio tool-chain, and extend `re2c`
to make it easier to consume from Win32 applications, both native and managed.
All changes should be confined as possible to the Win32 directory to reduce the pain of
porting changes from the master repository.

## Build instructions

To build, you need to restore the packages from the same directory as this file.
This project uses the `paket` system, so you will need to run:

```cmd
.paket\paket.exe restore
```

## Roadmap

1. Compile `re2c.boostrap` executable. _DONE_

1. Compile `re2c` executable. _DONE_

1. Package `re2c` executable in a `nuget` package with `MSBuild` rules.

### Nice to have

Eventually, it would be nice to have the following as well:

1. Run the entire test suite using the generated toolchain.

1. Performance comparison against the standard toolchain.

## Notes on building

Observe that there are separate projects, which compile to static libraries,
for `adfa`, `dfa`, `dfa.cfg`, and `nfa`. These projects have source files with
the identical names, and otherwise we would have conflicts. Separating them
to different projects solves this problem, but may reduce the opportunities
for global program optimizations (this should not really be a big problem).

We follow the same approach of compiling to static libraries for
`code`, `re`, `skeleton`, and `util` as well.
The motivation is to simplify the `re2c.bootstrap` and `re2c` projects.

The build process generates a very large number of warnings (`C4129`) similar to:

```
 e2csrcstlex.re(640): warning C4129: 'c': unrecognized character escape sequence
```

They are due to the `#line` directives, and can be ignored; they are currently disabled.