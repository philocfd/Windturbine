#!/bin/bash

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
#topoSet -dict system/topoSetDict
#refineMesh -dict system/refineMeshDict_c1 -overwrite

#Refinement 2 - Mid size rectangle
topoSet -dict system/topoSetDict
refineMesh -dict system/refineMeshDict_c2 -overwrite

#Refinement 3 - Small rectangle close to the body
topoSet -dict system/topoSetDict
refineMesh -dict system/refineMeshDict_c3 -overwrite


#In 2D we must use extrudeMesh in the base mesh to avoid the pyramids
#It also reduces the cell count for the next stage in snappy
extrudeMesh -noFunctionObjects
