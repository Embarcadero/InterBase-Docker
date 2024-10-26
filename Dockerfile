# Build Stage
FROM ubuntu:jammy AS builder

ENV IB_URL=https://altd.embarcadero.com/download/interbase/2020/Update6/InterBase_2020_Linux.zip

# Install required packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -yy install --no-install-recommends \
    curl \
    unzip \
    && apt-get -y autoremove \
    && apt-get -y autoclean \
    && rm -rf /var/lib/apt/lists/*

# Extract InterBase
RUN curl -L "${IB_URL}" -k -o ./ibinstall.zip \
    && unzip ibinstall.zip -d /install \
    && rm -rf ibinstall.zip

# Runtime stage
FROM ubuntu:jammy

ENV PREFIX=/opt/interbase
ENV LICENSEPATH=/opt/interbase/license
ENV VOLUME=/interbase
ENV DBPATH=/interbase/database
ENV BKPPATH=/interbase/restore

VOLUME ["/interbase"]

# Copy InterBase installer, the ref. file with default values for instalation, start script
COPY --from=builder /install /install
COPY values.txt /install/values.txt
COPY iblibraries.sh /install/iblibraries.sh
COPY entrypoint.sh ${PREFIX}/entrypoint.sh

# Configure /etc/services
RUN echo "gds_db 3050/tcp gds_db # InterBase server" >> /etc/services \
    echo "gds_db 3050/tcp #InterBase Server" >> /etc/services

WORKDIR /install

# Run InterBase installer
RUN chmod +x ./install_linux_x86_64.sh \
    && ./install_linux_x86_64.sh -f ./values.txt \
    && chmod +x ./iblibraries.sh \
    && ./iblibraries.sh \
    && rm -rf ../install \
    && chmod +x ${PREFIX}/entrypoint.sh

WORKDIR /interbase

# 3050 is standard InterBase port
EXPOSE 3050

# Execute InterBase start script
ENTRYPOINT [ "/opt/interbase/entrypoint.sh" ]

CMD ["interbase"]