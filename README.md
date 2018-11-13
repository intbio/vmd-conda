# gromacs-conda

Anaconda recipe for [VMD](http://www.ks.uiuc.edu/Research/vmd/).
Compiles VMD 64-bit with Python support.



## Building 
```
conda install conda-build
#conda install anaconda-client

#For OSX you'll need to download older compatible SDK
#See here https://conda.io/docs/user-guide/tasks/build-packages/compiler-tools.html

conda-build -c conda-forge vmd_VERSION

#VMD is a licenced product, so you'll need to store the build in your customly hosted repository

```


## Installing 

```
conda install -c conda-forge -c PATH_TO_CHANNEL vmd=1.9.3
```
