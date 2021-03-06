# vmd-conda

Anaconda recipe for [VMD](http://www.ks.uiuc.edu/Research/vmd/).
Compiles VMD 64-bit with Python support.

## Contents

- vmd_1.9.3 is VMD made with
     - For Mac: MACOSXX86_64 LP64 FLTKOPENGL FLTK TK  TCL PTHREADS  ACTC COLVARS  LIBTACHYON  LIBPNG NETCDF TDCONNEXION

- vmd_1.9.3_py is VMD made with
     - For Mac: MACOSXX86_64 LP64 FLTKOPENGL FLTK TK  TCL PTHREADS  ACTC COLVARS  LIBTACHYON  LIBPNG NETCDF TDCONNEXION PYTHON   NUMPY



## Building 


```
conda install conda-build
#conda install anaconda-client

#For OSX you'll need to download older compatible SDK 10.9
# And add 3dconnexion framework there
#See here https://conda.io/docs/user-guide/tasks/build-packages/compiler-tools.html
#See https://github.com/phracker/MacOSX-SDKs/releases
conda-build -c conda-forge vmd_1.9.3

#VMD is a licenced product, so you'll need to store the build in your customly hosted repository

```


## Installing 

```
git clone git@github.com:intbio/conda.git
conda install -c conda-forge -c "file:/$PWD/conda" vmd=1.9.3
conda install -c conda-forge -c "file:/$PWD/conda" vmd_py=1.9.3
```
