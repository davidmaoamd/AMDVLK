FROM ubuntu
RUN  mkdir amdvlk
WORKDIR /amdvlk
RUN  apt-get update && apt-get install -y build-essential python3 cmake curl g++-multilib gcc-multilib libx11-dev libxcb1-dev x11proto-dri2-dev libxcb-dri3-dev libxcb-dri2-0-dev libxcb-present-dev libxshmfence-dev python git
RUN  update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
RUN  git config --global user.email "david.mao@amd.com" && git config --global user.name "David Mao" && git config --global color.ui false
RUN  mkdir drivers
WORKDIR /amdvlk/drivers
RUN  git clone https://github.com/GPUOpen-Drivers/AMDVLK.git -b master && git clone https://github.com/GPUOpen-Drivers/xgl.git -b master && git clone https://github.com/GPUOpen-Drivers/pal.git -b master && git clone https://github.com/GPUOpen-Drivers/llvm.git -b amd-vulkan-master
WORKDIR /amdvlk/drivers/xgl
RUN  cmake -H. -Bbuilds/Release64 -DCMAKE_BUILD_TYPE=Release -DCMAKE_MODULE_PATH=$PWD/../pal/cmake/Modules -DXGL_PAL_PATH:PATH=$PWD/../pal -DCMAKE_C_FLAGS="-DLINUX -D__x86_64__ -D__AMD64__" -DCMAKE_CXX_FLAGS="-DLINUX -D__x86_64__ -D__AMD64__" -DXGL_LLVM_SRC_PATH=$PWD/../llvm
WORKDIR /amdvlk/drivers/xgl/builds/Release64
RUN  make -j`nproc`
WORKDIR /amdvlk/AMDVLK/docker/ubuntu
RUN ./buildpkg.sh /amdvlk/AMDVLK  1.0.0 /amdvlk/drivers/xgl/build/Release64/icd/amdvlk64.so /amdvlk/AMDVLK/json/Ubuntu/amd_icd64.json && cp build/amdvlk_*.deb /amdvlk/AMDVLK/package/ubuntu/amdvlk64.deb
WORKDIR /amdvlk/AMDVLK/package/ubuntu
RUN git add amdvlk64.deb && git commit -sm "update the package upon latest update" && git push 
