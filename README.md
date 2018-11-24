# vmd-conda

Anaconda recipe for [VMD](http://www.ks.uiuc.edu/Research/vmd/).
Compiles VMD 64-bit with Python support.



## Building 
Currently, this will not build correctly on OSX 10.14 - conda uses SDK 10.9, fltk will compile incorreclty.
Surprisingly, when built in 10.13 it will work on 10.14.

```
conda install conda-build
#conda install anaconda-client

#For OSX you'll need to download older compatible SDK
#See here https://conda.io/docs/user-guide/tasks/build-packages/compiler-tools.html
#See https://github.com/phracker/MacOSX-SDKs/releases
conda-build -c conda-forge vmd_1.9.3

#VMD is a licenced product, so you'll need to store the build in your customly hosted repository

```


## Installing 

```
git clone git@github.com:intbio/conda.git
conda install -c conda-forge -c "file:/$PWD/conda" vmd=1.9.3
```
