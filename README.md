# gromacs-conda

Anaconda recipe for [Gromacs](http://www.gromacs.org).
A very basic build - mainly to prepare files for an MD run on a computer cluster.



## Building and uploading to anaconda
```
conda install conda-build
conda install anaconda-client
anaconda login

#For OSX you'll need to download older compatible SDK
#See here https://conda.io/docs/user-guide/tasks/build-packages/compiler-tools.html

#conda config --add channels conda-forge
conda-build -c conda-forge gromacs_VERSION
anaconda upload path_to_package
```


## Installing from Anaconda cloud

```
conda install -c conda-forge -c intbio gromacs=2018.3
```
