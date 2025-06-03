FROM ubuntu:24.04
LABEL maintainer="Mariano Alberto García Mattío"

ENV PENTAHO_SERVER="/opt/pentaho-server"
ENV PATH="${PENTAHO_SERVER}:${PATH}"

# Instalar herramientas básicas y limpiar apt
RUN apt update && apt install -y wget unzip fontconfig fonts-dejavu && rm -rf /var/lib/apt/lists/*

# Eliminar documentación innecesaria
RUN apt-get purge -y manpages && \
    rm -rf /usr/share/man /usr/share/doc /usr/share/info

# Crear usuario y grupo pentaho
ARG PUID=1010
ARG PGID=1010

# Crear grupo solo si no existe, con verificación de nombre y GID
RUN groupadd -g ${PGID} pentaho || true && \
    useradd -u ${PUID} -g ${PGID} -m -s /bin/bash pentaho || true

WORKDIR /tmp

# Copiar archivos de instalación con ownership directo para pentaho
COPY --chown=pentaho:pentaho install-java.sh .
COPY --chown=pentaho:pentaho jdk-8-linux-x64.tar.gz .
COPY --chown=pentaho:pentaho pentaho-server-ce.zip .
COPY --chown=pentaho:pentaho pivot4j-pentaho-1.0-plugin.zip.1 ./pivot4j-pentaho-1.0-plugin.zip
COPY --chown=pentaho:pentaho datafor.zip.1 ./datafor.zip
COPY --chown=pentaho:pentaho jsf-api-1.1_02.jar .
COPY --chown=pentaho:pentaho ImportHandlerMimeTypeDefinitions.xml .
COPY --chown=pentaho:pentaho importExport.xml .
COPY --chown=pentaho:pentaho jcifs.jar .
COPY --chown=pentaho:pentaho jtds-1.2.5.jar .

# Descomprimir e instalar componentes
RUN ./install-java.sh -f jdk-8-linux-x64.tar.gz && \
    unzip pentaho-server-ce.zip -d /opt && \
    unzip pivot4j-pentaho-1.0-plugin.zip -d ${PENTAHO_SERVER}/pentaho-solutions/system && \
    unzip datafor.zip -d ${PENTAHO_SERVER}/pentaho-solutions/system && \
    mv jsf-api-1.1_02.jar ${PENTAHO_SERVER}/tomcat/webapps/pentaho/WEB-INF/lib && \
    mv jcifs.jar ${PENTAHO_SERVER}/tomcat/lib && \
    mv ImportHandlerMimeTypeDefinitions.xml ${PENTAHO_SERVER}/pentaho-solutions/system && \
    mv importExport.xml ${PENTAHO_SERVER}/pentaho-solutions/system && \
    mv jtds-1.2.5.jar ${PENTAHO_SERVER}/tomcat/lib 
    
#    rm ${PENTAHO_SERVER}/pentaho-solutions/system/kettle/plugins/pentaho-big-data-plugin/*.zip

#    rm ${PENTAHO_SERVER}/pentaho-solutions/ADDITIONAL-FILES/drivers/*.kar && \


# Habilitar autenticación por parámetro
# Desactivar prompt inicial y modo daemon
# Asignar permisos correctos a pentaho
# Hacer ejecutables los scripts necesarios
# Limpiar archivos temporales
RUN sed -i -e "s|requestParameterAuthenticationEnabled=false|requestParameterAuthenticationEnabled=true|g" ${PENTAHO_SERVER}/pentaho-solutions/system/security.properties && \
    rm ${PENTAHO_SERVER}/promptuser.sh && \
    sed -i 's/\(-Xmx6144m\)/\1 -Djava.awt.headless=true/' ${PENTAHO_SERVER}/start-pentaho.sh && \
    sed -i -e 's/\(exec ".*"\) start/\1 run/' ${PENTAHO_SERVER}/tomcat/bin/startup.sh && \
    chown -R pentaho:pentaho /opt && \
    chown -R pentaho:pentaho /tmp && \
    chown -R pentaho:pentaho /home/pentaho && \
    chmod +x ${PENTAHO_SERVER}/*.sh && \
    chmod +x ${PENTAHO_SERVER}/tomcat/bin/*.sh && \
    rm -rf /tmp/* /var/tmp/*

# Cambiar a usuario no root
USER pentaho

EXPOSE 8080
ENTRYPOINT ["/opt/pentaho-server/start-pentaho.sh"]
