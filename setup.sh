export libpath=$PWD/build/exlibs
export projectroot=$PWD
if ! cd $libpath
then
mkdir $PWD/build
mkdir $libpath
fi

# Git URLs
export sdl2_url="https://github.com/libsdl-org/SDL.git"
export sdl2_path="$libpath/sdl"
export sdl2_image_url="https://github.com/libsdl-org/SDL_image.git"
export sdl2_image_path="$libpath/SDL_Image"
export sdl2_ttf_url="https://github.com/libsdl-org/SDL_ttf"
export sdl2_ttf_path="$libpath/SDL_ttf"
export openal_url="https://github.com/kcat/openal-soft.git"
export openal_path="$libpath/openal-soft"
export physfs_url="https://github.com/icculus/physfs.git"
export physfs_path="$libpath/physfs"
export pixman_url="https://github.com/freedesktop/pixman.git"
export pixman_path="$libpath/pixman"
export sdlsound_url="https://github.com/Ancurio/SDL_sound.git"
export sdlsound_path="$libpath/SDL_sound"
export sigc_url="https://github.com/libsigcplusplus/libsigcplusplus/archive/refs/tags/2.10.7.tar.gz"
export sigc_path="$libpath/libsigcplusplus-2.10.7"
export zlib_url="https://github.com/zlib-ng/zlib-ng"
export zlib_path="$libpath/zlib-ng"
export bzip2_url="git://sourceware.org/git/bzip2.git"
export bzip2_path="$libpath/bzip2"
export libnsgif_url="git://git.netsurf-browser.org/libnsgif.git"
export libnsgif_path="$libpath/libnsgif"
export ruby_url="https://github.com/ruby/ruby.git"
export ruby_path="$libpath/ruby"
export vorbis_url="https://github.com/xiph/vorbis"
export vorbis_path="$libpath/vorbis"
export ogg_url="https://github.com/gcp/libogg"
export ogg_path="$libpath/libogg"

# Non-git
# Boost C++ Libraries
export boost_url="https://boostorg.jfrog.io/artifactory/main/release/1.78.0/source/boost_1_78_0.tar.gz"
export boost_path="$libpath/boost"
# libpng (required for SDL_Image)
export libpng_url="http://prdownloads.sourceforge.net/libpng/libpng-1.6.37.tar.gz\?download"
export libpng_path="$libpath/libpng"

# Functions.
downloadAndUntarGZ() {
    if [ ! -f $2.tar.gz ]
    then
        wget $1 -O $2.tar.gz
        mkdir $2
        tar xvzf $2.tar.gz -C $2
    else 
        echo "$2.tar.gz is already downloaded."
    fi
}
downloadAndUntarXZ() {
    if [ ! -f $2.tar.xz ]
    then
        wget $1 -O $2.tar.xz
        mkdir $2
        tar xvzf $2.tar.xz -C $2
    else
        echo "$2.tar.xz is already downloaded."
    fi
}
downloadAndUnzip() {
    if [ ! -f $2.zip ]
    then
        wget $1 -O $2.zip
        unzip $2.zip -d $2
    else
        echo "$2.zip is already downloaded."
    fi
}
makeinstall() {
    if [ "$OSTYPE" = "msys" ]; then
        make install
    else 
        sudo make install
    fi
}
# Main code.
echo "* Downloading zlib."
git clone $zlib_url $zlib_path
cd $zlib_path
cmake . -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DWITH_FUZZERS=ON -DWITH_CODE_COVERAGE=ON -DWITH_MAINTAINER_WARNINGS=ON
cmake --build . --config Release

echo "* Downloading bzip2."
git clone $bzip2_url $bzip2_path
cd $bzip2_path
#mkdir build
#cd build
#cmake .. -G "Unix Makefiles"
#cmake --build . --config Release
#make check
make
if [ "$OSTYPE" = "msys" ]; then
    make install
else
    sudo make install
fi

echo "* Downloading libogg"
git clone $ogg_url $ogg_path
cd $ogg_path
./autogen.sh
make
make install

echo "* Downloading boost."
downloadAndUntarGZ $boost_url $boost_path
cd $boost_path/boost_1_78_0
./bootstrap.sh --prefix=/usr/local
if [ "$OSTYPE" = "msys" ]; then
    ./b2 install --prefix=/usr/local
else
    sudo ./b2 install --prefix=/usr/local
fi

echo "* Downloading PhysFS."
git clone $physfs_url $physfs_path
cd $physfs_path
echo "* Building."
cmake -B build/ -G "Unix Makefiles"
cd build
make
makeinstall

echo "* Downloading pixman."
git clone $pixman_url $pixman_path
cd $pixman_path
echo "* Building pixman."
./autogen.sh
./configure
make
makeinstall

echo "* Downloading sigc++"
downloadAndUntarGZ $sigc_url $sigc_path
cd $sigc_path/libsigcplusplus-2.10.7
echo "* Building sigc++."
./autogen.sh
./configure --prefix=/usr/local
make 
makeinstall
if [ "$OSTYPE" = "msys" ]; then
cp sigc++config.h /usr/local/include/sigc++-2.0
else
sudo cp sigc++config.h /usr/local/include/sigc++-2.0/
fi

echo "* Downloading libpng."
downloadAndUntarGZ $libpng_url $libpng_path
echo "* Building libpng."
cd $libpng_path
./configure
make check
makeinstall

echo "* Downloading libnsgif."
git clone $libnsgif_url $libnsgif_path
cd $libnsgif_path
echo "* Building libnsgif."
make
makeinstall

echo "* Downloading SDL2."
git clone $sdl2_url $sdl2_path
cd $sdl2_path
mkdir build
cd build
../configure 
make
makeinstall

echo "* Downloading vorbis."
git clone $vorbis_url $vorbis_path
echo "* Building vorbis."
cd $vorbis_path
./autogen.sh
./configure
make

echo "* Downloading OpenAL Soft."
git clone $openal_url $openal_path
echo "* Building and installing OpenAL Soft."
cd $openal_path
mkdir build
cd build
cmake .. -G "Unix Makefiles"
make
makeinstall

echo "* Downloading SDL Sound from Ancurio."
git clone $sdlsound_url $sdlsound_path
cd $sdlsound_path
echo "* Building and installing SDL_Sound."
./bootstrap
./configure
make 
makeinstall

echo "* Downloading SDL_Image."
git clone $sdl2_image_url $sdl2_image_path
cd $sdl2_image_path
echo "* Building SDL_Image."
./configure
make 
makeinstall

echo "* Downloading SDL_ttf."
git clone $sdl2_ttf_url $sdl2_ttf_path
cd $sdl2_ttf_path
echo "* Building SDL_ttf"
./configure
make
makeinstall

echo "* Now, final boss... Downloading ruby."
git clone $ruby_url $ruby_path
cd $ruby_path
echo "* Building"
./autogen.sh
./configure
make
makeinstall

echo "* All done! Now, you can build ModShot."