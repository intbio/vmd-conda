#!/bin/bash

# VMD required libraries http://www.ks.uiuc.edu/Research/vmd/allversions/related_programs.html

echo "!!!!!!!!!!!!!!!"
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
make -j 8
make install


cd ..
cd ..
cd ..
cd ..

export PLUGINDIR="$PWD/vmd-1.9.3/plugins"
export export TCLINC=-I/System/Library/Frameworks/Tcl.framework/Versions/8.5/Headers
export export TCLLIB=-L/System/Library/Frameworks/Tcl.framework/Versions/8.5/Headers
cd plugins
make   MACOSXX86_64 TCLINC=$TCLINC TCLLIB=$TCLLIB
make   distrib 
cd ../vmd-1.9.3

echo "MACOSXX86_64 LP64 FLTKOPENGL PYTHON FLTK TK  TCL PTHREADS PYTHON NUMPY " > configure.options
#This is what we want
#MACOSXX86_64 FLTKOPENGL FLTK COLVARS IMD TK TCL NOSILENT PTHREADS LIBTACHYON ACTC LP64 NETCDF PYTHON NUMPY
#NUMPY  - vmdnumpy is tricky
#Fix code
sed -i.bak 's/MACOSX/MACOSXX86/g' bin/vmd.sh
sed -i.bak 's/MACOSX/MACOSXX86/g' bin/vmd.csh
sed -i.bak 's/__APPLE__/__APPLE__NO/g' src/VMDTkinterMenu.h
sed -i.bak 's/__APPLE__/__APPLE__NO/g' src/PythonTextInterp.h
sed -i.bak 's/__APPLE__/__APPLE__NO/g' src/PythonTextInterp.C
sed -i.bak 's/__APPLE__/__APPLE__NO/g' src/py_commands.h

#export VMDINSTALLNAME='vmd'
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
make veryclean
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