# OSFM-Core-Public
[![Build Modshot](https://github.com/Speak2Erase/OSFM-Core-Public/actions/workflows/build-standalone.yaml/badge.svg)](https://github.com/speak2erase/OSFM-Core-Public/actions/workflows/build-standalone.yaml)[![Build Modshot with Steam support](https://github.com/speak2erase/OSFM-Core-Public/actions/workflows/build-steam.yaml/badge.svg)](https://github.com/speak2erase/OSFM-Core-Public/actions/workflows/build-steam.yaml)[![Build Modshot with MSYS2](https://github.com/speak2erase/OSFM-Core-Public/actions/workflows/build-mys2.yml/badge.svg)](https://github.com/Speak2Erase/OSFM-Core-Public/actions/workflows/build-mys2.yml)
---

This is a even more MORE specialized fork of a specialized fork of [OSFM-Public-Core by Speak2Erase](https://github.com/Speak2Erase/OSFM-Core-Public) ([mkxp by Ancurio](https://github.com/Ancurio/mkxp) designed for [*OneShot*](http://oneshot-game.com/)) for OneShot mods.

Thanks to [hunternet93](https://github.com/hunternet93) for starting the reimplementation of the journal program!

Thanks to [rkevin-arch](https://github.com/rkevin-arch) for the docker build!

Thanks to [somedevfox](https://github.com/somedevfox) for helping ModShot ditch conan!

> mkxp is a project that seeks to provide a fully open source implementation of the Ruby Game Scripting System (RGSS) interface used in the popular game creation software "RPG Maker XP", "RPG Maker VX" and "RPG Maker VX Ace" (trademark by Enterbrain, Inc.), with focus on Linux. The goal is to be able to run games created with the above software natively without changing a single file.
>
> It is licensed under the GNU General Public License v2+.

*ModShot* also makes use of [steamshim](https://hg.icculus.org/icculus/steamshim/) for GPL compliance while making use of Steamworks features. See LICENSE.steamshim.txt for details.
You can compile ModShot with steam without compiling steamshim, but you will need to source the steamshim binary yourself.

## Building

Conan is no longer supported. Long live conan.
Instead, ModShot now makes use of meson, bash, and make, in a fairly simple setup. You only need to compile dependencies once.

Because of this, compiling with Visual Studio as was standard before is no longer supported, and instead compiling using the msys2 toolset is required.
The main upshot of this, of course, is remaining on par with ruby in terms of gem support. (at least for windows)

Previously, C extensions were very jank with ModShot, **however** now you can use a C extension right from your own Ruby install!
(Provided the version is the same, and the msys2 evironment is the same. I'll get back to this later.)

# Building on Windows

First, you'll need to download [msys2](https://www.msys2.org/) and install it. 
Then, you'll want to determine what Ruby version you're using, as this will determine what build environment you'll be using.
As is, ModShot is set up to use Ruby 3.1, so keep that in mind. Please refer to this table to determine the environment.
(You *can* use the wrong environment and it will work fine, just not with C extensions.)

```
Ruby >3.1 UCRT64
Ruby 3.0-2.0 MINGW64
Ruby <1.9 MINGW32
```

Once you've figured out the environment you need to use, pull up an msys2 shell of it.
(You can search the environment name in the Windows search box to open it)
From there, it's pretty much identical to the Linux setup.

```sh
# Install dependencies from package manager
sh setup.sh

# Build extra dependencies (like ruby)
cd windows; make
source vars.sh

cd ..; meson build --prefix="$PWD/build.out" --bindir=.
cd build && ninja install
```

# Building on Linux

Building on Linux is fairly easy, as long as you're using one of the supported distros. (Manjaro, Debian/Ubuntu, Fedora/Red Hat)
Unlinke Windows, you don't have to worry about msys2 environments. Just use gcc and you'll be good to go.
If you're not, fear not, as you can usually just install all the dependencies right from your package manager. See `setup.sh`.

```sh
# Install dependencies from package manager
sh setup.sh

# Build extra dependencies (like ruby)
cd linux; make
source vars.sh

cd ..; meson build --prefix="$PWD/build.out" --bindir=.
cd build && ninja install
```

This should create a folder called `out` with your build of ModShot all ready to go!

## Sepecific ruby versions

When running `make` in the second step, you'll want to pass in an argument telling make what Ruby version to use:
```sh
make RUBY_VER='3.0'
```
This is a blunt method however and will not let you use a specific exact version, just a specific version with a major number.

Then, in the meson step, pass in an argument to specify the Ruby version:
```sh
meson build build --prefix="$PWD/build.out" --bindir=. -Dmri_version="3.0"
```

ModShot should handle the rest.

## Configuration

*ModShot* reads configuration data from the file "oneshot.conf". The format is ini-style. Do *not* use quotes around file paths (spaces won't break). Lines starting with '#' are comments. See 'oneshot.conf.sample' for a list of accepted entries. Note that this feature appears to be brpken for the moment until we get around to fixing it. Using command line options does work, however.

All option entries can alternatively be specified as command line options. Any options that are not arrays (eg. preloaded scripts) specified as command line options will override entries in oneshot.conf. Note that you will have to wrap values containing spaces in quotes (unlike in oneshot.conf).

The syntax is: `--<option>=<value>`

Example: `./oneshot --gameFolder="oneshot" --vsync=true`

### External gems

Modshot builds come pre-packaged with the ruby standard library in `/lib/ruby/`. You can require gems from this folder at any point by using `require '<gem>'`.

You can ship your own gems by finding the gem install location (Typically `C:\Ruby27-x64\lib\ruby\gems\2.7.0\gems`), going inside the gem, and copying over all the files inside lib. 

