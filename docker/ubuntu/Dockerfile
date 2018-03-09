FROM ubuntu
RUN  mkdir amdvlk
WORKDIR /amdvlk
RUN  apt-get update && apt-get install -y build-essential python3 cmake curl g++-multilib gcc-multilib libx11-dev libxcb1-dev x11proto-dri2-dev libxcb-dri3-dev libxcb-dri2-0-dev libxcb-present-dev libxshmfence-dev python git
RUN  update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
RUN  git config --global user.email "david.mao@amd.com" && git config --global user.name "David Mao" && git config --global color.ui false
RUN  mkdir drivers
WORKDIR /amdvlk/drivers
RUN  git clone https://github.com/davidmaoamd/AMDVLK.git -b master && git clone https://github.com/GPUOpen-Drivers/xgl.git -b master && git clone https://github.com/GPUOpen-Drivers/pal.git -b master && git clone https://github.com/GPUOpen-Drivers/llvm.git -b amd-vulkan-master
WORKDIR /amdvlk/drivers/xgl
RUN  cmake -H. -Bbuilds/Release64
WORKDIR /amdvlk/drivers/xgl/builds/Release64
RUN  make -j`nproc`
WORKDIR /amdvlk/drivers/AMDVLK/docker/ubuntu
RUN ./buildpkg.sh /amdvlk/drivers/AMDVLK  1.0.0 /amdvlk/drivers/xgl/build/Release64/icd/amdvlk64.so /amdvlk/drivers/AMDVLK/json/Ubuntu/amd_icd64.json && cp build/amdvlk_*.deb /amdvlk/drivers/AMDVLK/package/ubuntu/amdvlk64.deb
WORKDIR /amdvlk/drivers/AMDVLK/package/ubuntu
RUN git config --global push.default simple 
RUN git add amdvlk64.deb && git commit -sm "update the package upon latest update" && git push origin 
