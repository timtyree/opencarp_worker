
#run the basic installer after mounting your opencarp docker image
# following https://git.opencarp.org/openCARP/meshalyzer/-/blob/master/INSTALL.md
#run the installer included in the official docker-image
./install_script.sh /usr/local/bin
##the following might be redundant with ^that
# make
# cd _build
# make


#install dependencies


#the meshalyzer installation manual suggests installing fltk from source to avoid config-esque exceptions.
#I tried to installk fltk from source for 20 minutes without success... moving on...

#Ubuntu
apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    fluid \
    freeglut3-dev \
    g++ \
    git \
    libfltk1.3-dev \
    libglew-dev \
    libglu1-mesa-dev \
    libpng-dev \
    make

#install vtk
#default python version 3.6.9
python -m pip install --upgrade pip
python -m pip install vtk
cp /usr/local/lib/python3.6/dist-packages/vtk /usr/lib/vtk

# #install vtk
apt install cmake libavcodec-dev libavformat-dev libavutil-dev libboost-dev libdouble-conversion-dev libeigen3-dev libexpat1-dev libfontconfig-dev libfreetype6-dev libgdal-dev libglew-dev libhdf5-dev libjpeg-dev libjsoncpp-dev liblz4-dev liblzma-dev libnetcdf-dev libnetcdf-cxx-legacy-dev libogg-dev libpng-dev libpython3-dev libqt5opengl5-dev libqt5x11extras5-dev libsqlite3-dev libswscale-dev libtheora-dev libtiff-dev libxml2-dev libxt-dev qtbase5-dev qttools5-dev zlib1g-dev -y
git clone https://gitlab.kitware.com/vtk/vtk.git
cd vtk
git checkout v8.2.0
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$HOME/vtk-inst \
    -DCMAKE_INSTALL_RPATH=$HOME/vtk-inst \
    -DVTK_Group_Qt=ON \
    -DVTK_QT_VERSION=5 \
    -DVTK_Group_Imaging=ON \
    -DVTK_Group_Views=ON \
    -DModule_vtkRenderingFreeTypeFontConfig=ON \
    -DVTK_WRAP_PYTHON=ON \
    -DVTK_PYTHON_VERSION=3 \
    -DPYTHON_EXECUTABLE=/usr/bin/python3 \
    -DPYTHON_INCLUDE_DIR=/usr/include/python3.6 \
    -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.6m.so \
    -DBUILD_TESTING=OFF \
    -DVTK_USE_SYSTEM_LIBRARIES=ON \
    -DVTK_USE_SYSTEM_LIBPROJ4=OFF \
    -DVTK_USE_SYSTEM_GL2PS=OFF \
    -DVTK_USE_SYSTEM_LIBHARU=OFF \
    -DVTK_USE_SYSTEM_PUGIXML=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    ..
make -j$(($(nproc) - 1))
make install



# http://libpng.org/pub/png/libpng.html
# wget 'http://downloads.sourceforge.net/projects/libpng/1.6.37/libpng-1.6.37.tar.xz'
#unclear how to install ^that
apt-get install libomp-dev -y

#from fltk/README.Unix.txt
# git clone https://github.com/fltk/fltk.git
# ./fltk/install-sh
#   sudo apt-get install g++
#   sudo apt-get install gdb
#   sudo apt-get install subversion
#   sudo apt-get install autoconf
#   sudo apt-get install libx11-dev
#   sudo apt-get install libglu1-mesa-dev
# These two are optional, but highly recommended:
#   sudo apt-get install libasound2-dev
#   sudo apt-get install libxft-dev
# make install

#install glew
git clone https://github.com/nigels-com/glew.git glew
cd glew/auto
make
cd ..
./cmake-testbuild.sh
make install
# make

# MacOS
# brew install libpng
# brew install fltk
# brew install git
# brew install cmake

#Compile meshalyzer
git clone https://git.opencarp.org/openCARP/meshalyzer.git
cd meshalyzer
apt-get install cmake-curses-gui -y
#press c to configure
#edit not-found directories
GLEW_DIR="/usr/lib64/libGLEW.so"
VTK_DIR="/root/vtk-inst"

     VTKConfig.cmake
     vtk-config.cmake

   Add the installation prefix of "VTK" to CMAKE_PREFIX_PATH or set "VTK_DIR"


 CMAKE_INSTALL_PREFIX            */usr/local                                                                 
 FLTK_CONFIG_SCRIPT              */usr/bin/fltk-config                                                       
 FLTK_DIR                        */usr/lib/fltk                                                              
 FLTK_MATH_LIBRARY               */usr/lib/x86_64-linux-gnu/libm.so                                          
 GLEW_DIR                        *GLEW_DIR-NOTFOUND="/usr/lib64/libGLEW.so"                                                          
 USE_VTK                         *ON                                                                         
 VTK_DIR                         *VTK_DIR-NOTFOUND="/root/vtk-inst"                                                           
 X11_xcb_icccm_INCLUDE_PATH      *X11_xcb_icccm_INCLUDE_PATH-NOTFOUND                                        
 X11_xcb_icccm_LIB               *X11_xcb_icccm_LIB-NOTFOUND                                                 
 X11_xcb_util_INCLUDE_PATH       *X11_xcb_util_INCLUDE_PATH-NOTFOUND                                         
 X11_xcb_util_LIB                *X11_xcb_util_LIB-NOTFOUND                                                  
 X11_xcb_xfixes_INCLUDE_PATH     */usr/include                                                               
 X11_xcb_xfixes_LIB              */usr/lib/x86_64-linux-gnu/libxcb-xfixes.so


make


