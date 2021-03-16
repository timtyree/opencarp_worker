#build homebrew on linux
# git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
# mkdir ~/.linuxbrew/bin
# ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
# eval $(~/.linuxbrew/bin/brew shellenv)

#install prerequisites
brew install libpng
brew install fltk
brew install git
brew install cmake
# VTK_LIBDIR = /usr/local/lib???
# VTK_INCDIR = /usr/local/include/vtk-8.?

#compile
git clone https://git.opencarp.org/openCARP/meshalyzer.git
cd meshalyzer
# cmake -S. -B_build  #requires VTK to bloody work
cmake -S. -B_build -DUSE_VTK=OFF
cmake --build _build

# docker build -f Dockerfile -t proj:myapp .