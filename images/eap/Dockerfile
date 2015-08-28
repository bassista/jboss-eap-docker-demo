FROM demo_basejdk

MAINTAINER Thomas Qvarnstrom <tqvarnst@redhat.com>

ENV EAP_VERSION 6.3.0

ADD ./jboss-eap-${EAP_VERSION}.zip /tmp/

USER jboss

RUN /usr/bin/unzip -q /tmp/jboss-eap-${EAP_VERSION}.zip -d /opt/jboss

RUN mv /opt/jboss/jboss-eap-* /opt/jboss/jboss-eap-${EAP_VERSION} 

RUN /opt/jboss/jboss-eap-${EAP_VERSION}/bin/add-user.sh admin admin-123 --silent


ADD ./simpledemo.war /opt/jboss/jboss-eap-${EAP_VERSION}/standalone/deployments/

RUN sed -i "s/enable-welcome-root=\"true\"/enable-welcome-root=\"false\"/g" /opt/jboss/jboss-eap-${EAP_VERSION}/standalone/configuration/standalone.xml

# Set the Java Opts
ENV JAVA_OPTS -client -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xverify:none -Xms64m -Xmx256m -Dorg.apache.tomcat.util.LOW_MEMORY=true -XX:+UseCompressedOops -XX:+AggressiveOpts -XX:+DisableExplicitGC -Djava.net.preferIPv4Stack=true

ENV PRESERVE_JAVA_OPTS true

CMD /opt/jboss/jboss-eap-${EAP_VERSION}/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
