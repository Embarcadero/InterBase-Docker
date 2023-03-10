FROM ubuntu:bionic

# Install required packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -yy install --no-install-recommends \
    unzip \
    && apt-get -y autoremove \
    && apt-get -y autoclean

# Configure /etc/services
RUN echo "gds-db 3050/tcp gds_db # InterBase server" >> /etc/services \
    echo "gds_db 3050/tcp #InterBase Server" >> /etc/services

# Install Interbase
COPY values.txt ./values.txt

ADD https://altd.embarcadero.com/download/interbase/2020/Update4/InterBase_2020_Linux.zip ./ibinstall.zip
RUN unzip ibinstall.zip
RUN chmod +x install_linux_x86_64.sh
RUN sh ./install_linux_x86_64.sh -f values.txt

# Remove Interbase install leftovers
RUN rm ibinstall.zip
RUN rm ib_install_linux_x86_64.bin
RUN rm install_linux_x86_64.sh
RUN rm install_linux_x86.sh
RUN rm ib_install_linux_x86.bin
RUN rm -rf ./setup

# Add start script
COPY ibstart.sh ./ibstart.sh
RUN chmod +x ./ibstart.sh
CMD ./ibstart.sh

# 3050 is standard Interbase port
EXPOSE 3050