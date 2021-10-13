FROM ubuntu:18.04
MAINTAINER Mariano Alberto García Mattío

ENV PENTAHO_SERVER /opt/pentaho-server

RUN apt update
RUN apt install wget unzip -y
WORKDIR /tmp
COPY install-java.sh .
COPY jdk-8-linux-x64.tar.gz .
COPY pentaho-server-ce.zip .
COPY pivot4j-pentaho-1.0-plugin.zip.1 ./pivot4j-pentaho-1.0-plugin.zip
COPY datafor.zip.1 ./datafor.zip
COPY jsf-api-1.1_02.jar .

RUN ./install-java.sh -f jdk-8-linux-x64.tar.gz
RUN unzip /tmp/pentaho-server-ce.zip -d /opt
RUN unzip /tmp/pivot4j-pentaho-1.0-plugin.zip -d /opt/pentaho-server/pentaho-solutions/system
RUN unzip /tmp/datafor.zip -d /opt/pentaho-server/pentaho-solutions/system
RUN mv /tmp/jsf-api-1.1_02.jar /opt/pentaho-server/tomcat/webapps/pentaho/WEB-INF/lib

#Eliminar Drivers BigData (probado solo en versión 9)
#RUN rm ${PENTAHO_SERVER}/pentaho-solutions/ADDITIONAL-FILES/drivers/*.kar
#RUN rm ${PENTAHO_SERVER}/pentaho-solutions/system/kettle/plugins/pentaho-big-data-plugin/*.zip

#Inhabilitar el prompt inicial por las actualizaciones
RUN rm ${PENTAHO_SERVER}/promptuser.sh
#Inhabilitar el modo demon de Tomcat
RUN sed -i -e 's/\(exec ".*"\) start/\1 run/' ${PENTAHO_SERVER}/tomcat/bin/startup.sh

RUN rm /tmp/pentaho-server-ce.zip
RUN rm /tmp/jdk-8-linux-x64.tar.gz
RUN rm /tmp/install-java.sh
RUN rm /tmp/pivot4j-pentaho-1.0-plugin.zip
RUN rm /tmp/datafor.zip

RUN chmod +x ${PENTAHO_SERVER}/*.sh
RUN chmod +x ${PENTAHO_SERVER}/tomcat/bin/*.sh

RUN PATH="${PENTAHO_SERVER}:$PATH"
RUN export PATH

EXPOSE 8080

ENTRYPOINT ["/opt/pentaho-server/start-pentaho.sh"]
