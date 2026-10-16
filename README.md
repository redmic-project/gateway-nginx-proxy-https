# Nginx proxy HTTPS

Nginx service configured to act as a proxy to Traefik service

Este servicio sirve de proxy inverso al frente de *Traefik*, aunque las funciones que aporta ya podrían ser resueltas directamente por este.

## Funciones

* Complementa a Traefik (que actúa a nivel interno) como punto de entrada a los servicios web. Recibe peticiones para cualquier dominio, y las propaga para que sean resueltas por Traefik hacia los contenedores apropiados.

* Sirve a través de HTTPS todos los servicios, que funcionan sobre HTTP (o HTTPS si es necesario) localmente. Carga los certificados y los parámetros Diffie-Hellman con la ayuda de [certificates-manager](https://gitlab.com/redmic-project/gateway/certificates-manager).

* Comprime las respuestas a las peticiones con gzip, disminuyendo el tráfico de red.

## Volúmenes

Se definen diferentes volúmenes para lograr persistencia del servicio, al mismo tiempo que se mantienen separados ficheros de distinta índole.

### persistent-vol

Almacena aquellos ficheros que no son secretos y que interesa conservar entre reinicios del servicio, como los parámetros Diffie-Hellman. Se trata de un volumen externo al servicio.

### accesslog-vol

Mantiene la persistencia de los ficheros de logs de acceso, para que puedan ser consumidos por otros servicios que monten el volumen.

## Configuraciones

Para poder contemplar varios casos de uso (según entorno de despliegue, por ejemplo) se definen configs de Docker, estáticas para el servicio pero que permiten mayor flexibilidad.

### default

Define los servers que darán el servicio.

### ssl-params

Provee los parámetros relativos al uso de certificados.

### ssl-certs

Provee la importación de los certificados para su uso.

### gzip

Mantiene una relación de extensiones a comprimir y los parámetros usados para ello.

### redirect

Varios ficheros de configuración que albergan reglas de redirección entre dominios.

### access-log

Define una estructura de salida para los logs de acceso.

## Secretos

Del mismo modo que con las configs, se usan secrets de Docker para almacenar aquellas configuraciones que además no deben ser públicas.

### cert-chain

Contenido del fichero `chain.pem` del certificado.

### cert-fullchain

Contenido del fichero `fullchain.pem` del certificado.

### cert-privkey

Contenido del fichero `privkey.pem` del certificado.
