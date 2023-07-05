#!/bin/bash
#SBATCH -p wzhcnormal
#SBATCH -N 1
#SBATCH --ntasks-per-node=32
module purge

# Source tutorial run functions
module load compiler/devtoolset/7.3.1
module load mpi/openmpi/4.1.1/gcc-7.3.1
source /public/software/apps/OpenFOAM/9/openmpi-4.1.1-gcc-7.3.1/OpenFOAM-9/etc/bashrc
. $WM_PROJECT_DIR/bin/tools/RunFunctions

rm *.obj > /dev/null 2>&1
rm -rf 0 > /dev/null 2>&1
foamCleanTutorials

#surfaceFeatures -noFunctionObjects

blockMesh
#topoSet
#subsetMesh c1 -overwrite


#This is not compatible with refinementRegions in SHM dictionary
#Must select region here

#Refinement 1 - Large rectangle
topoSet -dict system/topoSetDict
refineMesh -dict system/refineMeshDict_c1 -overwrite

#Refinement 2 - Mid size rectangle
topoSet -dict system/topoSetDict
refineMesh -dict system/refineMeshDict_c2 -overwrite

#Refinement 3 - Small rectangle close to the body
topoSet -dict system/topoSetDict
refineMesh -dict system/refineMeshDict_c3 -overwrite



#In 2D we must use extrudeMesh in the base mesh to avoid the pyramids
#It also reduces the cell count for the next stage in snappy
extrudeMesh -noFunctionObjects



#This shifting gives problems in SHM only if the locainto in mesh point is inside of a non hexa element
#You have to be careful to put the poin in a region with hexes
#I do this shifting to have the doamin in -0.5:0.5 personal choice not needed
transformPoints 'translate=(0 0 -1.5)'

#Decompose mesh for snappyHex
runApplication decomposePar
mpirun snappyHexMesh -noFunctionObjects -overwrite -parallel | tee log.shm
runApplication reconstructParMesh  -latestTime -constant

checkMesh -latestTime | tee log.checkmesh3d

extrudeMesh -noFunctionObjects

transformPoints 'translate=(0 0 -1.0)'

checkMesh -latestTime | tee log.checkmesh2d

createPatch  -overwrite

rm -r processor*
