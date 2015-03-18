FROM demo_basejdk

MAINTAINER Thomas Qvarnstrom <tqvarnst@redhat.com>

ENV EAP_VERSION 6.3.0

ADD ./jboss-eap-${EAP_VERSION}.zip /tmp/

USER jboss

RUN /usr/bin/unzip -q /tmp/jboss-eap-${EAP_VERSION}.zip -d /opt/jboss

## Fix for the fact that base dir doesn't match the current version.
RUN mv /opt/jboss/jboss-eap-* /opt/jboss/jboss-eap-${EAP_VERSION} 

RUN /opt/jboss/jboss-eap-${EAP_VERSION}/bin/add-user.sh admin admin-123 --silent


ADD ./simpledemo.war /opt/jboss/jboss-eap-${EAP_VERSION}/standalone/deployments/

RUN sed -i "s/enable-welcome-root=\"true\"/enable-welcome-root=\"false\"/g" /opt/jboss/jboss-eap-${EAP_VERSION}/standalone/configuration/standalone.xml

#ENV JAVA_OPTS "-Xms128m -Xmx128m -XX:MaxNewSize=96m -XX:MaxPermSize=96m -Dorg.apache.tomcat.util.LOW_MEMORY=true -Djava.net.preferIPv4Stack=true"

# Set the Java Opts
ENV JAVA_OPTS -client -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xverify:none -Xms64m -Xmx256m -Dorg.apache.tomcat.util.LOW_MEMORY=true -XX:+UseCompressedOops -XX:+AggressiveOpts -XX:+DisableExplicitGC -Djava.net.preferIPv4Stack=true
#ENV JAVA_OPTS -XX:+DoEscapeAnalysis -XX:+UseCompressedOops -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC -XX:+ExplicitGCInvokesConcurrent -XX:CMSInitiatingOccupancyFraction=80 -XX:CMSIncrementalSafetyFactor=20 -XX:+UseCMSInitiatingOccupancyOnly -Xmx256M -Xms256M -XX:+AggressiveOpts -Dorg.apache.tomcat.util.LOW_MEMORY=true

#Force the JAva Opts to be preseved (e.g. not changed by standalone.sh)
ENV PRESERVE_JAVA_OPTS true

CMD /opt/jboss/jboss-eap-${EAP_VERSION}/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0