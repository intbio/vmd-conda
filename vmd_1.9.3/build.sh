#!/bin/bash
#mkdir build
#cd build
#export DYLD_LIBRARY_PATH=/opt/MacOSX10.9.sdk/usr/lib/system/:$DYLD_LIBRARY_PATH
export MACOSX_DEPLOYMENT_TARGET=10.9 # - helps on some OSX platforms
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
ls -l