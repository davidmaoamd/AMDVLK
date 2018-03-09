#!/bin/bash
# record the current path
BuildDir=`pwd`
echo $PWD
# arguments:
# 1: path to amdvlk repo
# 2: the version for amdvlk, something like 1.0.0
# 3: the driver binary
# 4: the json file
# absolute path is required and relative path is not supported.
# eg: ./buildpkg.sh /home/AMDVLK/  1.0.0 /home/amdvlk64.so /home/amd_icd64.json
AmdvlkPath=$1
AmdvlkVersion=$2
AmdvlkDriver=$3
JsonFile=$4
# collect short hash for llvm/pal/xgl/amdvlk git project.
cd $AmdvlkPath
cd drivers/AMDVLK
# 1: AMDVLK head short hash
AmdvlkHash=`git log --pretty=oneline --abbrev-commit | cut -d " " -f1 | head -n1`
# 2: xgl head short hash
cd ../xgl
VulkanHash=`git log --pretty=oneline --abbrev-commit | cut -d " " -f1 | head -n1`
# 3: pal head short hash
cd ../pal
PalHash=`git log --pretty=oneline --abbrev-commit | cut -d " " -f1 | head -n1`
# 4: llvm head short hash
cd ../llvm
LLVMHash=`git log --pretty=oneline --abbrev-commit | cut -d " " -f1 | head -n1`

# back to package directory.
cd $BuildDir
# create directory and make template ready
echo "Setting up environment...."
rm -rf build
mkdir -p build/buildpkg
cd build/buildpkg/
mkdir DEBIAN
# copy the driver to the build directory.
echo "copy driver ...."
mkdir -p usr/lib/x86_64-linux-gnu
cp $AmdvlkDriver usr/lib/x86_64-linux-gnu/amdvlk64.so
# generate control and md5sums
echo "Generating control file ...."
echo -e `\
         `"Package: amdvlk\n"`
         `"Source: amdvlk\n"`
         `"Version: $AmdvlkVersion-xgl~$VulkanHash-pal~$PalHash-llvm~$LLVMHash\n"`
         `"Architecture: amd64\n"`
         `"Maintainer: Advanced Micro Devices (AMD) <jian-rong.jin@amd.com>\n"`
         `"Depends: libc6 (>= 2.17), libgcc1 (>= 1:3.3.1), libstdc++6 (>= 4.6)\n"`
         `"Section: libs\n"`
         `"Priority: optional\n"`
         `"Multi-Arch: same\n"`
         `"Homepage: https://github.com/GPUOpen-Drivers/AMDVLK\n"`
         `"Description: AMD Open Source Vulkan driver\n"` `> DEBIAN/control
# generate amdPalSettings.cfg"
echo "Gnerating amdPalSettings.cfg"
mkdir -p etc/amd
echo "MaxNumCmdStreamsPerSubmit,4" > etc/amd/amdPalSettings.cfg
# copy json file
echo "Copying json file ..."
mkdir -p usr/share/vulkan/icd.d
cp ${JsonFile} usr/share/vulkan/icd.d/

echo "Gnerating md5sums ..."
md5sum usr/lib/x86_64-linux-gnu/amdvlk64.so usr/share/vulkan/icd.d/amd_icd64.json etc/amd/amdPalSettings.cfg > DEBIAN/md5sums

echo "Generating package ..."
cd ..
dpkg -b buildpkg amdvlk_${AmdvlkHash}_amd64.deb
echo "clean up build directory"
rm -rf buildpkg
echo "done"
