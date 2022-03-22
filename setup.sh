export libpath=$PWD/build/exlibs
export projectroot=$PWD

if ! cd $libpath
then
    mkdir $PWD/build
    mkdir $libpath
fi

export proc_count=$(nproc --all)

if [[ $OSTYPE == msys ]]; then 
    echo "* MinGW-w64 detected."
    echo "* Installing dependencies..."
    pacman -S pactoys --noconfirm
    pacboy -S git: gcc:p make:p cmake:p bison: doxygen:p ruby:p \
     SDL2:p SDL2_image:p SDL2_ttf:p openal:p \
     physfs:p pixman:p libwebp:p zlib:p zeromq:p \
     bzip2:p libvorbis:p libogg:p zeromq:p \
     boost:p libpng:p libjpeg-turbo:p libtiff:p --noconfirm
     
else 
    if [[ "$(cat /etc/issue)" == Debian* || "$(cat /etc/issue)" == Ubuntu* ]]; then
        echo "* Debian Linux detected."
        echo "* Installing dependencies..."
        sudo apt install -y gcc make cmake bison doxygen ruby \
         libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev libopenal-dev \
         libphysfs-dev libpixman-1-dev libwebp-dev libbz2-dev \
         libvorbis-dev libogg-dev libsodium-dev libboost-dev libpng-dev \
         libjpeg-dev libtiff-dev 

        echo "* ZeroMQ not found in Debian's repositories. Building from source..."
        git clone https://github.com/zeromq/libzmq.git $libpath/zmq
        cd $libpath/zmq
        ./autogen.sh
        ./configure --with-libsodium
        make -j$proc_count
        sudo make install
        sudo ldconfig
    fi

    if [[ "$(cat /etc/issue)" == Manjaro* ]]; then
        echo "* Manjaro detected."
        echo "* Installing dependencies..."

        sudo pacman --noconfirm -S gcc make cmake bison doxygen ruby \
        sdl2 openal pixman libwebp bzip2 libvorbis libogg libsodium \
        libpng libjpeg libtiff zeromq
        echo "* Installing dependencies with pamac..."
        sudo pamac install sdl2_image sdl2_ttf physfs boost boost-libs \
        libsigc++ sdl_sound m4 --no-confirm
    fi

    if cat /etc/redhat-release; then
        echo "* RedHat/Fedora Linux detected."
        echo "* Installing dependencies..."
        sudo dnf install gcc make m4 cmake bison doxygen ruby mm-common \
	    SDL2 SDL2-devel SDL2_image SDL2_image-devel \
        bzip2-devel libwebp libwebp-devel libvorbis libvorbis-devel \
        libpng libpng-devel libjpeg-turbo libjpeg-turbo-devel libogg \
	    libogg-devel libtiff libtiff-devel libsodium libsodium-devel \
	    zeromq zeromq-devel physfs physfs-devel pixman pixman-devel \
        bzip2 openal-soft speex speex-devel libmodplug libmodplug-devel \
        boost boost-devel openal-soft-devel xfconf xfconf-devel gtk2 gtk2-devel \
        vim

        echo "* Building SDL2_ttf."
        git clone https://github.com/libsdl-org/SDL_ttf $libpath/SDL_ttf
        cd $libpath/SDL_ttf
        if [[ $OSTYPE == msys ]]; then
            ./configure --prefix=/ucrt64
        else
            ./configure --prefix=/usr
        fi
        if [[ $OSTYPE == msys ]]; then
            make install
        else 
            sudo make install
        fi
    fi
fi

echo "* Building libsigc++ from source..."
git clone https://github.com/libsigcplusplus/libsigcplusplus $libpath/sigc
cd $libpath/sigc
git checkout libsigc++-2-10
./autogen.sh
./configure --prefix=/usr
make
if [[ $OSTYPE == msys ]]; then
    make install
else 
    sudo make install
fi

echo "* Building libnsgif from source..."
git clone https://github.com/jcupitt/libnsgif-autotools $libpath/libnsgif
cd $libpath/libnsgif
./autogen.sh
./configure
make -j$proc_count
if [[ $OSTYPE == msys ]]; then
    make install
else 
    sudo make install
fi

echo "* Building SDL_Sound from source..."
git clone https://github.com/icculus/SDL_sound $libpath/SDL_Sound
cd $libpath/SDL_Sound
cmake . -DCMAKE_INSTALL_PREFIX=/usr
make -j$proc_count
if [[ $OSTYPE == msys ]]; then
    make install
else 
    sudo make install
fi

echo "* Building ZMQPP Binding from source..."
git clone https://github.com/zeromq/zmqpp $libpath/zmqpp
cd $libpath/zmqpp
cmake . -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr
make -j$proc_count
if [[ $OSTYPE == msys ]]; then
    make install
else 
    sudo make install
fi

echo "* Building Ruby from source..."
git clone https://github.com/ruby/ruby $libpath/ruby
cd $libpath/ruby
git checkout ruby_3_0
./autogen.sh
./configure --enable-shared --prefix=/usr
make -j$proc_count
if [[ $OSTYPE == msys ]]; then
    make install
else 
    sudo make install
fi

