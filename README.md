# Titan-Kernel

This kernnel is made for the i386 processor and is not compatible with the amd64 processor.
Its tested using the acer aspire 5951g and the acer aspire one 7571g.

to run the kernel use the command make run alternativly use the iso in the iso folder and use a tool like rufus to burn usb stick.

The latest stable iso can be found in releases.
The latest development iso can be found in the iso folder /iso/Titan-dev.iso


# Commands

## wsl to build the kernel

```
wsl -d Ubuntu

cd /mnt/c/Users/robbe/Desktop/Titan-Kernel

make clean

make

make run (test iso)

exit

```


## wsl fix/setup i686-elf-gcc

```
wsl -d Ubuntu

sudo apt update
sudo apt install -y build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo

mkdir -p ~/cross/src
cd ~/cross/src

wget https://ftp.gnu.org/gnu/binutils/binutils-2.36.tar.gz
tar xf binutils-2.36.tar.gz
mkdir binutils-build
cd binutils-build
../binutils-2.36/configure --target=i686-elf --prefix=/usr/local/cross --with-sysroot --disable-nls --disable-werror
make
sudo make install

cd ~/cross/src
wget https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.gz
tar xf gcc-10.2.0.tar.gz
mkdir gcc-build
cd gcc-build
../gcc-10.2.0/configure --target=i686-elf --prefix=/usr/local/cross --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
sudo make install-gcc
sudo make install-target-libgcc


nano ~/.bashrc
-> export PATH="/usr/local/cross/bin:$PATH"

source ~/.bashrc

i686-elf-gcc --version
-> i686-elf-gcc (GCC) 10.2.0

```