FROM amazoncorretto:17

ENV SOAPUI_VERSION 5.7.0

# Download and unarchive SoapUI
RUN mkdir -p /opt &&\
    curl  https://s3.amazonaws.com/downloads.eviware/soapuios/${SOAPUI_VERSION}/SoapUI-${SOAPUI_VERSION}-linux-bin.tar.gz \
    | gunzip -c - | tar -xf - -C /opt && \
    ln -s /opt/SoapUI-${SOAPUI_VERSION} /opt/SoapUI

# Remove deprecated library
# @version 5.7.0
# @see https://community.smartbear.com/t5/SoapUI-Open-Source-Questions/XQuery-assertions-are-broken-with-SoapUI-5-6-0/td-p/207783
#RUN rm /opt/SoapUI/lib/xmlbeans-xpath-2.6.0.jar \
#       /opt/SoapUI/lib/xmlbeans-3.1.1-sb-fixed.jar \
# && curl -o /opt/SoapUI/lib/xmlbeans-3.1.0.jar https://repo.maven.apache.org/maven2/org/apache/xmlbeans/xmlbeans/3.1.0/xmlbeans-3.1.0.jar

# Copy extensions to soap ui
COPY .gitignore ./ext/* /opt/SoapUI/bin/ext/

# Download mysql connector
RUN curl -o /opt/SoapUI/bin/ext/mysql-connector-java.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.27/mysql-connector-java-8.0.27.jar

# Set environment
ENV PATH ${PATH}:/opt/SoapUI/bin

WORKDIR /opt/SoapUI/bin
ENTRYPOINT ["testrunner.sh"]
