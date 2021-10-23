# Install GALAXY on ROS
FROM ros:galactic

# linux/amd64 or linux/arm64
ARG TARGETPLATFORM

# For amd64
ARG GALAXY_AMD=http://gb.daheng-imaging.com/EN/Software/Cameras/Linux/Galaxy_Linux-x86_Gige-U3_32bits-64bits_1.2.2107.9261.tar.gz

# For arm64
ARG GALAXY_ARM=http://gb.daheng-imaging.com/EN/Software/Cameras/Linux/Galaxy_Linux-armhf_Gige-U3_32bits-64bits_1.3.2107.9261.tar.gz

# Copy cmake package files
COPY GALAXYConfig.cmake GALAXYConfigVersion.cmake .

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Install
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
  wget -O GALAXY.tar.gz ${GALAXY_AMD} --no-check-certificate; \
  elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
  wget -O GALAXY.tar.gz ${GALAXY_AMD} --no-check-certificate; \
  else exit 1; fi \
  && mkdir GALAXY \
  && tar -xzf GALAXY.tar.gz --strip-components=1 -C GALAXY \
  && (printf "\nY\nEn\n" && cat) | GALAXY/Galaxy_camera.run \
  && mv Galaxy_camera /opt/GALAXY \
  && rm -r GALAXY.tar.gz GALAXY

# Move libraries out of <arch> and plug in cmake package files
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
  mv /opt/GALAXY/lib/x86_64/* /opt/GALAXY/lib \
  && rmdir /opt/GALAXY/lib/x86_64; \
  elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
  mv /opt/GALAXY/lib/armv8/* /opt/GALAXY/lib \
  && rmdir /opt/GALAXY/lib/armv8; \
  else exit 1; fi \
  && mv GALAXYConfig.cmake GALAXYConfigVersion.cmake /opt/GALAXY

# Update ldconfig
RUN echo "/opt/GALAXY/lib" >> /etc/ld.so.conf.d/GALAXY.conf \
  && ldconfig
