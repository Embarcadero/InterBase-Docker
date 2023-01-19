FROM ubuntu:bionic

COPY values.txt ./values.txt
COPY ibstart.sh ./ibstart.sh

RUN echo "gds-db 3050/tcp gds_db # InterBase server" >> /etc/services
RUN echo "gds_db 3050/tcp #InterBase Server" >> /etc/services

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -yy install --no-install-recommends \
    unzip \
    && apt-get -y autoremove \
    && apt-get -y autoclean

ADD https://altd.embarcadero.com/download/interbase/2020/Update4/InterBase_2020_Linux.zip ./ibinstall.zip
RUN unzip ibinstall.zip
RUN chmod +x install_linux_x86_64.sh
RUN sh ./install_linux_x86_64.sh -f values.txt

RUN rm ibinstall.zip
RUN rm ib_install_linux_x86_64.bin
RUN rm install_linux_x86_64.sh
RUN rm install_linux_x86.sh
RUN rm ib_install_linux_x86.bin
RUN rm -rf ./setup

EXPOSE 3050

RUN chmod +x ./ibstart.sh
CMD ./ibstart.sh