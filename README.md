# Docker Pentaho Server

**Que es Pentaho Server?**
Se trata de un software de inteligencia de negocios de código abierto escrito en java que permite, entre otras cosas, ejecutar componentes de inteligencia de negocios como:
- Análisis dinámicos u OLAP (mediante Mondrian como motor y gran cantidad de herramientas gráficas como Pivot4J)
- Reportes (mediante Pentaho Reporting)
- Procesos de Integración de Datos (mediante Pentaho Data Integration)
- Tableros de mando (mediante CDF/CDE/CDA)
- etc
Cabe aclarar que Pentaho Server es uno de los componentes de la Suite Pentaho (ahora Hitachi Ventara), algunos de los otros componetes como Pentaho reporting y Pentaho Data Integration son independientes y poseen una interface gráfica de tipo desktop, aunque Pentaho Data Integration posee una excelente interface web llamada [WebSpoon](https://github.com/HiromuHota/webspoon-docker)  

**Crear y ejecutar contenedor**
```
docker run --name mipentahoserver -d -p 8080:8080 magm3333/pentahoserver
```

**Crear la imagen**
Una vez clonado este repositorio deberá:
- Descargar la versión 8 del JDK de Oracle y asegurate que poseá este nombre: *jdk-8-linux-x64.tar.gz* cuando lo descargues, se puede encontrar [aquí](https://www.oracle.com/java/technologies/javase/javase8u211-later-archive-downloads.html), también [aquí](https://gist.github.com/hgomez/9650687) hay una serie de comandos para descargarlo con wget, por ejemplo.
> wget https://github.com/frekele/oracle-java/releases/download/8u201-b09/jdk-8u201-linux-x64.tar.gz -O jdk-8-linux-x64.tar.gz 
- Descargar Pentaho Server CE, asegurate que posea el nombre *pentaho-server-ce.zip* cuando lo descargues, puedes utilizar este [enlace](https://razaoinfo.dl.sourceforge.net/project/pentaho/Pentaho%209.0/server/pentaho-server-ce-9.0.0.0-423.zip), por ejemplo: 
> wget https://razaoinfo.dl.sourceforge.net/project/pentaho/Pentaho%209.0/server/pentaho-server-ce-9.0.0.0-423.zip -O pentaho-server-ce.zip
- Finalmente, crear la imagen:

```
docker build -t pentahoserver .
```

**Crear un contenedor**

En base a tu imagen local

```
docker run --name mipentahoserver -d -p 8080:8080 pentahoserver
```

En base a la imagen de dockerhub

Ultima versión:

```
docker run --name pentahoserver91 -d -p 8080:8080 magm3333/pentahoserver
```

Versión específica

```
docker run --name pentahoserver91 -d -p 8080:8080 magm3333/pentahoserver:9.1ce
```


Puedes ver el log de tu contenedor de la siguiente manera:

```
docker logs mipentahoserver
```

Finalmente podrás disfrutar de tu Pentaho server accediendo a la url: *http://localhost:8080/pentaho* 

**Actualizar o agregar drivers JDBC**
Los drivers JDBC extra se encuentran en la carpeta /opt/pentaho-server/tomcat/lib dentro del contenedor, una vez ue tu contener se ha creado y está corriendo, puedes ver el contenido de la carpeta de la siguiente forma:
```
docker exec -it mipentahoserver bash -c "ls -lsh /opt/pentaho-server/tomcat/lib"
```
Se puede actualizar el driver de mysql de la siguiente forma:
```
docker cp ~/Descargas/mysql-connector-java-5.1.48-bin.jar  mipentahoserver:/opt/pentaho-server/tomcat/lib/mysql-connector-java-5.1.17.jar
```
En el caso anterior se descargó la versión 5.1.48 del driver y se colocó en ~/Descargas, finalmente se sobreescribió el driver existente a fin de no tener que eliminarlo, aunque te recomiendo hacerlo. 
Ahora debes reinicisar el contenedor para que el nuevo driver comience a funcionar:
```
docker restart mipentahoserver
```
Si deseas agregar nuevos drivers, solo debes usar el compando * docker cp*

**Aclaraciones**

La versión 9.1ce es la más pulida, ya se encuentran instalados los pluguins:

1) Pivot4J
2) Visualizer (en español), se puede ver un excelente tutorial introductorio aquí: (https://www.linkedin.com/pulse/visualizer-dashboards-mondrian-olap-en-pentaho-dario-bernabeu/)

**Agradecimientos**
- La instalación del JDK se realiza con una pequeña modificación del script creado por [chrishantha](https://github.com/chrishantha/install-java
- A mi queridx amigx [Darío Bernabeu](http://troyanx.com/Hefesto/bernabeu_dario.html), compañerx de aventuras, aprendizajes y demás cosas importantes de la vida.
- A [Ubuntu Peronista](https://ubuntuperonista.blogspot.com/) por sus constantes aportes a la causa.
- Esta imagen está basada en *ubuntu:18.04*


**TODO**
- Ejemplo de cambio de Time Zone
- Agregar versiones anteriores

***

**Licencia**

Creado por Mariano Alberto García Mattío en 2020 (Twitter [@magm3333](https://twitter.com/magm3333))

Licensed under the Apache License, Version 2.0
