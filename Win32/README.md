# re2c under Windows

The goal is to be able to compile `re2c` using the Visual Studio tool-chain, and extend `re2c`
to make it easier to consume from Win32 applications, both native and managed.
All changes should be confined as possible to the Win32 directory to reduce the pain of
porting changes from the master repository.

## Build instructions

The simplest thing is to run `build.bat` from this directory.
Make sure that you are running from a prompt that has been initialized to use the
Visual C compiler. The output will be in the `build` directory.

To build manually (e.g. from Visual Studio), you need to first restore the packages from
the same directory as this file. This project uses the `paket` system, so you will need to run:

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

1. Generate the help file `help.cc` automatically; currently we are using the
   version from the `bootstrap` directory. The way to generate would be to first
   produce the `help.rst` file from `help.rst.in` (in the `re2c\doc` directory),
   then use `rst2man` (which is a python package; hence, requires python in the environment
   and the appropriate packages), and then some string manipulation to transform the
   text file into the `C` file. Probably, the easiest approach would be just generate
   the output through a script, or a custom build task (the transformation looks easy).

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