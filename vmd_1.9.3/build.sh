#!/bin/bash

# VMD required libraries http://www.ks.uiuc.edu/Research/vmd/allversions/related_programs.html

echo "!!!!!!!!!!!!!!!"
echo $PREFIX

if [[ $target_platform == osx* ]]; then


#export DYLD_LIBRARY_PATH=/opt/MacOSX10.9.sdk/usr/lib/system/:$DYLD_LIBRARY_PATH
export MACOSX_DEPLOYMENT_TARGET=10.9 # - helps on some OSX platforms
#Compile plugins first
export PLUGINDIR="$(pwd)/vmd-1.9.3/plugins"
cd plugins
make   MACOSXX86_64
export export TCLINC=”-I$PREFIX/include”
export export TCLLIB=”-I$PREFIX/lib”
make   distrib TCLINC=$TCLINC TCLLIB=$TCLLIB
cd ../vmd-1.9.3
# echo "MACOSXX86_64 LP64 FLTKOPENGL FLTK TK TDCONNEXION LIBTACHYON NETCDF TCL PYTHON PTHREADS NUMPY ACTC GCC" > configure.options
echo "MACOSXX86_64 LP64  FLTK FLTKOPENGL TK  NETCDF TCL PTHREADS  GCC" > configure.options


#Fix code
sed -i.bak 's/MACOSX/MACOSXX86/g' bin/vmd.sh
sed -i.bak 's/MACOSX/MACOSXX86/g' bin/vmd.csh


#export VMDINSTALLNAME='vmd'
export VMDINSTALLBINDIR=$PREFIX/bin #/usr/local/bin
export VMDINSTALLLIBRARYDIR=$PREFIX/vmd #/usr/local/lib/$install_name
export PYTHON_INCLUDE_DIR=$PREFIX/include/python2.7
export PYTHON_LIBRARY=$PREFIX/lib/python2.7/config
export TCL_INCLUDE_DIR=$PREFIX/include/
export TCL_LIBRARY_DIR=$PREFIX/lib/

./configure 
cd src
#fix Makefile
sed -i.bak 's/tk8.5-x11/tk8.5/g' Makefile
sed -i.bak 's/tcl8.5-x11/tcl8.5/g' Makefile
sed -i.bak 's/lfltk-x11/lfltk/g' Makefile

make -j 8
make install
## See INSTALL of gromacs distro
# cmake .. \
#   -DSHARED_LIBS_DEFAULT=OFF \
#   -DBUILD_SHARED_LIBS=OFF \
#   -DGMX_PREFER_STATIC_LIBS=YES \
#   -DGMX_BUILD_OWN_FFTW=ON \
#   -DGMX_DEFAULT_SUFFIX=ON \
#   -DREGRESSIONTEST_DOWNLOAD=ON \
#   -DGMX_MPI=OFF \
#   -DGMX_GPU=OFF \
#   -DGMX_SIMD=SSE2 \
#   -DGMX_USE_OPENCL=OFF \
#   -DCMAKE_PREFIX_PATH=$PREFIX \
#   -DGMX_INSTALL_PREFIX=$PREFIX \
#   -DCMAKE_INSTALL_PREFIX=$PREFIX \
#   -DCMAKE_OSX_SYSROOT=/opt/MacOSX10.9.sdk/ \
#   -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9
# #make -j 8
# make
# make check
# make install

fi