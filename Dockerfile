FROM openjdk:8-jdk

RUN useradd opentsdb && \
    apt-get update && \
    apt-get install --no-install-recommends -y build-essential autoconf automake gnuplot-nox git && \
    apt-get clean && \
    git clone https://github.com/OpenTSDB/opentsdb.git /opt/opentsdb && \
    cd /opt/opentsdb && \
    chmod +x build-bigtable.sh && \
    ./build-bigtable.sh && \
    ./build-bigtable.sh install && \
    curl -sL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" > /usr/sbin/gosu && \
    echo "5b3b03713a888cee84ecbf4582b21ac9fd46c3d935ff2d7ea25dd5055d302d3c  /usr/sbin/gosu" | sha256sum -c && \
    chmod +x /usr/sbin/gosu

COPY ./logback.xml /etc/opentsdb/logback.xml
COPY ./run.sh /run.sh
COPY ./unprivileged.sh /unprivileged.sh

VOLUME /var/cache/opentsdb

ENTRYPOINT ["/run.sh"]
