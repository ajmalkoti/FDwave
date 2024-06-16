# FDwave

The code includes the finite difference modeling for elastic media.
**Features**

1. Works for flat topography
2. Use a Staggered grid, fourth order accurate scheme with leapfrog marching scheme.
3. Contains several examples in the directory named "scripts."

Here is one snippet of the result generated using the FDwave code.

     

**Content in package**:
FDWAVE: This directory contains all the programs & functions related to seismic modeling.  
SCRIPTS: This directory contains sample files for the simulation of different models.


**How to run the program**
1. Sample scripts are provided in the script directory. One may simply run those scripts.
2. Before running the code make sure to include the subroutine FDwave_initialize in the beginning of scripts.  
3. To avoid any (remote) possibility of conflict with other subroutines while running other codes, FDwave_deinitialize can be included at the end of scripts.

**Other package requirements**:
1. SEGYMat: To read the segy file, which should be added to the directory FDwave\Other_packages


**Getting help** about a function (with name say fun_name) can be obtained by typing the function name, i.e., "help fun_name".
References:

    Malkoti, A., Vedanti, N., Tiwari, R. K., 2018. An algorithm for fast elastic wave simulation using a vectorized finite difference operator. Computers & Geosciences 116, 23-31

    Malkoti, A., Vedanti, N., Tiwari, R. K., 2018. Viscoelastic modeling with a vectorized finite difference operator.
