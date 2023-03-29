FROM amazoncorretto:11

ENV SOAPUI_VERSION 5.4.0
ENV MYSQL_CONNECTOR_VERSION 8.0.32

# Install gzip and tar
RUN yum -y install gzip tar && yum -y clean all  && rm -rf /var/cache

# Download and unarchive SoapUI
RUN mkdir -p /opt &&\
    curl -s https://s3.amazonaws.com/downloads.eviware/soapuios/${SOAPUI_VERSION}/SoapUI-${SOAPUI_VERSION}-linux-bin.tar.gz  \
    | tar -xvz -C /opt && \
    ln -s /opt/SoapUI-${SOAPUI_VERSION} /opt/SoapUI

# Download mysql connector
RUN cd /opt/SoapUI/bin/ext \
    && curl -OJL https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-${MYSQL_CONNECTOR_VERSION}.tar.gz  \
    && tar -xvzf mysql-connector-j-${MYSQL_CONNECTOR_VERSION}.tar.gz mysql-connector-j-${MYSQL_CONNECTOR_VERSION}/mysql-connector-j-${MYSQL_CONNECTOR_VERSION}.jar --strip-components=1 \
    && rm mysql-connector-j-${MYSQL_CONNECTOR_VERSION}.tar.gz

# Set environment
ENV PATH ${PATH}:/opt/SoapUI/bin

WORKDIR /opt/SoapUI/bin
ENTRYPOINT ["testrunner.sh"]
