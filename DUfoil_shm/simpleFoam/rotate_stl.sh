#!/bin/bash
#SBATCH -p wzhcnormal
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
module purge
module load compiler/devtoolset/7.3.1
module load  mpi/hpcx/2.7.4/gcc-7.3.1
# Use OpenFOAM v2012 to use the -origin option of transformPoints, So we can specify the rotating center of
# rotating
module load apps/OpenFOAM/v2012/hpcx-gcc-7.3.1
export UCX_NET_DEVICES=mlx5_0:1
export UCX_IB_PCI_BW=mlx5_0:100Gbs
# Source tutorial run functions
. $WM_PROJECT_DIR/bin/tools/RunFunctions

#I do this shifting to have the doamin in -0.5:0.5 personal choice not needed
transformPoints  -origin "(0.25 0 0)" -rollPitchYaw "(0 0 -90)"  DU30.stl  DU30_rot90.stl

