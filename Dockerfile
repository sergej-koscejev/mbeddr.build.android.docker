FROM mbeddr/mbeddr.build.docker
MAINTAINER Sergej Koscejev <sergej@koscejev.cz>

ENV ANDROID_TOOLS_VERSION 25.2.3
ENV ANDROID_NDK_VERSION 13b
ENV ANDROID_CMAKE_VERSION 3.6.3155560
ENV ANDROID_HOME /opt/android
ENV ANDROID_SDK_COMPONENTS platform-tools,build-tools-25.0.1,android-25,extra-android-m2repository

ENV ANDROID_NDK_HOME /opt/android-ndk
ENV ANDROID_CMAKE_HOME /opt/android/cmake/${ANDROID_CMAKE_VERSION}

# SDK
RUN curl --silent --show-error --output /tmp/tools.zip https://dl.google.com/android/repository/tools_r${ANDROID_TOOLS_VERSION}-linux.zip && \
	unzip -q /tmp/tools.zip -d ${ANDROID_HOME} && rm /tmp/tools.zip

# Install Android SDK components
RUN echo y | ${ANDROID_HOME}/tools/android update sdk --silent --no-ui --all --filter "${ANDROID_SDK_COMPONENTS}"

# NDK
RUN curl  --silent --show-error --output /tmp/ndk.zip https://dl.google.com/android/repository/android-ndk-r${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
	unzip -q /tmp/ndk.zip -d /tmp && mv /tmp/android-ndk-r${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME} && rm /tmp/ndk.zip

# CMake
RUN curl  --silent --show-error --output /tmp/cmake.zip https://dl.google.com/android/repository/cmake-${ANDROID_CMAKE_VERSION}-linux-x86_64.zip && \
	mkdir -p ${ANDROID_CMAKE_HOME} && \
	unzip -q /tmp/cmake.zip -d ${ANDROID_CMAKE_HOME} && rm /tmp/cmake.zip
COPY cmake/package.xml ${ANDROID_CMAKE_HOME}/

# Use Java 8 instead of the default Java 7
RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
