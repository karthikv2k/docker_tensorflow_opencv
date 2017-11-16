FROM tensorflow/tensorflow:latest
MAINTAINER Karthik Ramasamy <karthikv2k@gmail.com>

RUN apt-get update && \
        apt-get install -y \
        cmake \
        git \
        wget \
        yasm \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libjasper-dev \
        libavformat-dev \
        libpq-dev \
        protobuf-compiler \
        python-pil \
        awscli \
        && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN wget https://github.com/opencv/opencv/archive/3.3.0.zip \
&& unzip 3.3.0.zip \
&& mkdir /opencv-3.3.0/cmake_binary \
&& cd /opencv-3.3.0/cmake_binary \
&& cmake -DBUILD_TIFF=ON \
  -DBUILD_opencv_java=OFF \
  -DWITH_CUDA=OFF \
  -DENABLE_AVX=ON \
  -DWITH_OPENGL=ON \
  -DWITH_OPENCL=ON \
  -DWITH_IPP=ON \
  -DWITH_TBB=ON \
  -DWITH_EIGEN=ON \
  -DWITH_V4L=ON \
  -DBUILD_TESTS=OFF \
  -DBUILD_PERF_TESTS=OFF \
  -DCMAKE_BUILD_TYPE=RELEASE \
  -DCMAKE_INSTALL_PREFIX=$(python -c "import sys; print(sys.prefix)") \
  -DPYTHON_EXECUTABLE=$(which python) \
  -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
  -DPYTHON_PACKAGES_PATH=$(python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") .. \
&& make -j4 \
&& make install \
&& rm /3.3.0.zip \
&& rm -r /opencv-3.3.0

RUN pip install keras \
        git+git://github.com/keplr-io/quiver.git \
        git+git://github.com/keplr-io/hera


# Quiver
EXPOSE 5000
# Hera
EXPOSE 5001