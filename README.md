# Overview

Dockerfile for Nim cross-compiler

## packages

- Nim: [dom96/choosenim](https://github.com/dom96/choosenim)
- CrossCompiler
    - Windows: [mingw-w64](https://packages.debian.org/search?keywords=mingw-w64)
    - MacOS: [tpoechtrager/osxcross](https://github.com/tpoechtrager/osxcross#packaging-the-sdk) -> [andrewd/osxcross](https://hub.docker.com/r/andrewd/osxcross/~/dockerfile/)
    - Linux: gcc-multilib is installed so compiling 32 bit works
    - Linux: [musl](https://packages.debian.org/search?suite=default&section=all&arch=any&searchon=names&keywords=musl)

# Usage

## Example compilation
```
echo 'echo "Hello World"' > hello.nim
docker run --rm -v `pwd`:/usr/local/src \
   chrishellerappsian/docker-nim-cross:latest \
   nim c --os:windows --cpu:amd64 --out:hello64.exe hello.nim

docker run --rm -v `pwd`:/usr/local/src \
    chrishellerappsian/docker-nim-cross:latest \
    nim c --os:macosx --cpu:amd64 --out:hello32.osx.bin hello.nim
```

Look at example directory.

## Adding libraries

See the example/libssh directory for an example of adding an
updated library to the build process.

The example brings [libssh2](https://libssh2.org/) up to date so that the Nim
[ba0f3/ssh2](https://github.com/ba0f3/ssh2.nim) module can be
built and tested.

See the test scripts ``test_sftp`` and ``test_scp`` for verifying
sftp and scp work properly from within your Nim code. Each shell script
should work unmodified to access the [public Rebex test server](https://test.rebex.net/)

## Directories in container

- /usr/local/src/: working dir
- /usr/bin/x86_64-w64-mingw32-gcc: compiler for 64 bit Windows
- /usr/bin/i686-w64-mingw32-gcc: compiler for 32 bit Windows
- /opt/osxcross/target/bin/o64-clang: compiler for 64 bit MacOSX
- /opt/osxcross/target/bin/o32-clang: compiler for 32 bit MacOSX
- /usr/bin/musl-gcc: compiler for Linux(musl)

## default command

default command is `bash`.

