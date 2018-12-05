#!/bin/bash

# VMD required libraries http://www.ks.uiuc.edu/Research/vmd/allversions/related_programs.html

echo "!!!!!!!!!!!!!!!"
echo $CC
echo $CXX
echo $CXXFLAGS

echo $PREFIX

if [[ $target_platform == osx* ]]; then


#export DYLD_LIBRARY_PATH=/opt/MacOSX10.9.sdk/usr/lib/system/:$DYLD_LIBRARY_PATH
export MACOSX_DEPLOYMENT_TARGET=10.9 # - helps on some OSX platforms
export OSX_VER=10.9

cd vmd-1.9.3/lib/fltk

wget http://fltk.org/pub/fltk/snapshots/fltk-1.4.x-r13117.tar.gz
tar -xf fltk-1.4.x-r13117.tar.gz

ln -s fltk-1.4.x-r13117 fltk

ln -s fltk include
cd fltk
make clean
./configure --prefix="$PWD/../MACOSXX86_64" --exec-prefix="$PWD/../MACOSXX86_64" --libdir="$PWD/../MACOSXX86_64" CXXFLAGS="-mmacosx-version-min=$OSX_VER" LDFLAGS="-mmacosx-version-min=$OSX_VER"
make -j 4
make install



cd ..
cd ..
cd ..
cd ..
export PLUGINDIR="$PWD/vmd-1.9.3/plugins"
export TCLINC=-I/System/Library/Frameworks/Tcl.framework/Versions/8.5/Headers
export TCLLIB=-L/System/Library/Frameworks/Tcl.framework/Versions/8.5/Headers
cd plugins
make   MACOSXX86_64 TCLINC=$TCLINC TCLLIB=$TCLLIB
make   distrib 
cd ..

#Let's make other libraries
cd vmd-1.9.3/lib/

mkdir -p actc
cd actc
wget https://downloads.sourceforge.net/project/actc/actc-source/1.1-final/actc-1.1.tar.gz
tar -xf actc-1.1.tar.gz
ln -s actc-1.1 include
ln -s actc-1.1 lib_MACOSXX86_64
cd actc-1.1
sed -i.bak 's%#include <malloc.h>%%g' tctest2.c
make CFLAGS=-D__linux__
cd ..
cd ..


# ACTC         - triangle mesh stripification library for higher speed surfaces
# AVX512       - enable use of AVX512 instructions on target CPU
# CUDA         - NVIDIA CUDA GPU acceleration functions
# OPENCL       - OpenCL CPU/GPU/Accelerator device support
# MPI          - MPI based message passing
# IMD          - include option for connecting to remote MD simulations
# VRPN         - include VRPN tracker lib for spatial trackers
# LIBSBALL     - Direct I/O Spaceball 6DOF input device
# XINERAMA     - Support for Xinerama-optimized full-screen mode
# XINPUT       - X-Windows XInput based Spaceball, Dial box, Button box

# TDCONNEXION  - 3DConnexion MacOS X driver for Spaceball 6DOF input devices
#Activate it if drivers installed

# LIBGELATO    - built-in rendering via Gelato library   
# LIBOPTIX     - built-in accelerated ray tracing for NVIDIA GPUs
# LIBOSPRAY    - built-in accelerated ray tracing for Intel CPUs
# +LIBTACHYON   - built-in raytracing via Tachyon (on CPUs)
cd tachyon
wget http://www.photonlimited.com/~johns/tachyon/files/0.99b6/tachyon-0.99b6.tar.gz
tar -xf tachyon-0.99b6.tar.gz
cd tachyon/unix
make linux-64
cd ..
cd ..
ln -s tachyon/src include
ln -s tachyon/compile/linux-64 lib_MACOSXX86_64
cp tachyon/compile/linux-64/tachyon tachyon_MACOSXX86_64
cd ..


# +LIBPNG       - PNG image output support # This can be installed through conda
# +NETCDF       - NetCDF file I/O library # This can be installed through conda
#Below we adk them to be linked statically


# NOSTATICPLUGINS - disable use of statically linked molfile plugins
# CONTRIB      - user contributed code for VMD which has restrictions
# +TCL          - The Tcl scripting language
# +PYTHON       - The Python scripting language
# +PTHREADS     - POSIX Threads Support
# +NUMPY        - Numeric Python extensions



cd ..

echo "MACOSXX86_64 LP64 FLTKOPENGL FLTK TK  TCL PTHREADS  ACTC COLVARS  LIBTACHYON  LIBPNG NETCDF TDCONNEXION PYTHON NUMPY" > configure.options



sed -i.bak 's/MACOSX$/MACOSXX86/g' bin/vmd.sh
sed -i.bak 's/MACOSX$/MACOSXX86/g' bin/vmd.csh
sed -i.bak 's/__APPLE__/__APPLE__NO/g' src/VMDTkinterMenu.h
sed -i.bak 's/__APPLE__/__APPLE__NO/g' src/PythonTextInterp.h
sed -i.bak 's/__APPLE__/__APPLE__NO/g' src/PythonTextInterp.C
sed -i.bak 's/__APPLE__/__APPLE__NO/g' src/py_commands.h

export VMDINSTALLNAME='vmd_py'
export VMDINSTALLBINDIR=$PREFIX/bin #/usr/local/bin
export VMDINSTALLLIBRARYDIR=$PREFIX/vmd #/usr/local/lib/$install_name
export PYTHON_INCLUDE_DIR=$PREFIX/include/python2.7
export NUMPY_INCLUDE_DIR=$PREFIX/lib/python2.7/site-packages/numpy/core/include
export PYTHON_LIBRARY=$PREFIX/lib/python2.7/site-packages/numpy/core/include
export NUMPY_LIBRARY=$PREFIX/lib/python2.7/site-packages/numpy
# export TCL_INCLUDE_DIR=$PREFIX/include/
# export TCL_LIBRARY_DIR=$PREFIX/lib/

./configure 
cd src
sed -i.bak 's/fltk-1.3.x/fltk/g' Makefile
sed -i.bak 's%../lib/tk/lib_MACOSXX86_64/Tk.framework/Versions/8.5/Headers%/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers%g' Makefile
sed -i.bak "s%INCDIRS     =%INCDIRS     = -I$PYTHON_INCLUDE_DIR%g" Makefile
sed -i.bak "s%INCDIRS     =%INCDIRS     = -I$NUMPY_INCLUDE_DIR%g" Makefile


sed -i.bak "s%LIBDIRS     =%LIBDIRS     = -L$PYTHON_LIBRARY%g" Makefile
sed -i.bak "s%LIBDIRS     =%LIBDIRS     = -L$NUMPY_LIBRARY%g" Makefile

sed -i.bak "s%-lpng%$PREFIX/../_build_env/lib/libpng.a%g" Makefile
sed -i.bak "s%-lnetcdf%$PREFIX/../_build_env/lib/libnetcdf.a%g" Makefile

# sed -i.bak "s%LIBDIRS     =%LIBDIRS     = $PREFIX/lib/libnetcdf.a $PREFIX/lib/libpng16.a%g" Makefile
# rm $PREFIX/lib/libnetcdf*dylib $PREFIX/lib/libpng*dylib

sed -i.bak "s%INCDIRS     =%INCDIRS     = -I$PREFIX/include -I$PREFIX/../_build_env/include%g" Makefile
sed -i.bak "s%LIBDIRS     =%LIBDIRS     = -L$PREFIX/lib -L$PREFIX/../_build_env/lib%g" Makefile
sed -i.bak "s%-framework Python%-lpython2.7%g" Makefile

sed -i.bak "s%INCDIRS     =%INCDIRS     = --sysroot=/opt/MacOSX10.9.sdk -D_FORTIFY_SOURCE=2 -mmacosx-version-min=10.9%g" Makefile
sed -i.bak "s%/System/Library/%/opt/MacOSX10.9.sdk/System/Library/%g" Makefile

make veryclean
make -j 4
make install
fi




if [[ $target_platform == linux* ]]; then


export PLUGINDIR="$PWD/vmd-1.9.3/plugins"
export export TCLINC=-I$PREFIX/include
export export TCLLIB=-L$PREFIX/lib
cd plugins
make   LINUXAMD64 TCLINC=$TCLINC TCLLIB=$TCLLIB
make   distrib 
cd ..

#Let's make other libraries
cd vmd-1.9.3/lib/

mkdir -p actc
cd actc
wget https://downloads.sourceforge.net/project/actc/actc-source/1.1-final/actc-1.1.tar.gz
tar -xf actc-1.1.tar.gz
ln -s actc-1.1 include
ln -s actc-1.1 lib_LINUXAMD64
cd actc-1.1
sed -i.bak 's%#include <malloc.h>%%g' tctest2.c
make CFLAGS=-D__linux__
cd ..
cd ..


# ACTC         - triangle mesh stripification library for higher speed surfaces
# AVX512       - enable use of AVX512 instructions on target CPU
# CUDA         - NVIDIA CUDA GPU acceleration functions
# OPENCL       - OpenCL CPU/GPU/Accelerator device support
# MPI          - MPI based message passing
# IMD          - include option for connecting to remote MD simulations
# VRPN         - include VRPN tracker lib for spatial trackers
# LIBSBALL     - Direct I/O Spaceball 6DOF input device
# XINERAMA     - Support for Xinerama-optimized full-screen mode
# XINPUT       - X-Windows XInput based Spaceball, Dial box, Button box

# TDCONNEXION  - 3DConnexion MacOS X driver for Spaceball 6DOF input devices
#Activate it if drivers installed

# LIBGELATO    - built-in rendering via Gelato library   
# LIBOPTIX     - built-in accelerated ray tracing for NVIDIA GPUs
# LIBOSPRAY    - built-in accelerated ray tracing for Intel CPUs
# +LIBTACHYON   - built-in raytracing via Tachyon (on CPUs)
cd tachyon
wget http://www.photonlimited.com/~johns/tachyon/files/0.99b6/tachyon-0.99b6.tar.gz
tar -xf tachyon-0.99b6.tar.gz
cd tachyon/unix
make linux-64
cd ..
cd ..
ln -s tachyon/src include
ln -s tachyon/compile/linux-64 lib_LINUXAMD64
cp tachyon/compile/linux-64/tachyon tachyon_LINUXAMD64
cd ..


# +LIBPNG       - PNG image output support # This can be installed through conda
# +NETCDF       - NetCDF file I/O library # This can be installed through conda
#Below we adk them to be linked statically


# NOSTATICPLUGINS - disable use of statically linked molfile plugins
# CONTRIB      - user contributed code for VMD which has restrictions
# +TCL          - The Tcl scripting language
# +PYTHON       - The Python scripting language
# +PTHREADS     - POSIX Threads Support
# +NUMPY        - Numeric Python extensions



cd ..

echo "LINUXAMD64 OPENGL OPENGLPBUFFER FLTK TK COLVARS IMD VRPN SILENT LIBSBALL XINPUT TCL PTHREADS ACTC LIBTACHYON LIBOPTIX LIBOSPRAY NETCDF PYTHON NUMPY CUDA XINERAMA" > configure.options



export VMDINSTALLNAME='vmd_py'
export VMDINSTALLBINDIR=$PREFIX/bin #/usr/local/bin
export VMDINSTALLLIBRARYDIR=$PREFIX/vmd #/usr/local/lib/$install_name
export PYTHON_INCLUDE_DIR=$PREFIX/include/python2.7
export NUMPY_INCLUDE_DIR=$PREFIX/lib/python2.7/site-packages/numpy/core/include
export PYTHON_LIBRARY=$PREFIX/lib/python2.7/site-packages/numpy/core/include
export NUMPY_LIBRARY=$PREFIX/lib/python2.7/site-packages/numpy

./configure 
cd src
# sed -i.bak 's/fltk-1.3.x/fltk/g' Makefile
# sed -i.bak 's%../lib/tk/lib_MACOSXX86_64/Tk.framework/Versions/8.5/Headers%/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers%g' Makefile
# sed -i.bak "s%INCDIRS     =%INCDIRS     = -I$PYTHON_INCLUDE_DIR%g" Makefile

# sed -i.bak "s%LIBDIRS     =%LIBDIRS     = -L$PYTHON_LIBRARY%g" Makefile

sed -i.bak "s%INCDIRS     =%INCDIRS     = -I$PREFIX/include%g" Makefile
sed -i.bak "s%LIBDIRS     =%LIBDIRS     = -L$PREFIX/lib%g" Makefile


make veryclean
make -j 4
make install

fi
