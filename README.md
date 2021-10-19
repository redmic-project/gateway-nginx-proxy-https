# Nginx proxy HTTPS

Nginx service configured to act as a proxy to Traefik service. Add bot protection capabilities

Este servicio sirve de proxy inverso al frente de *Traefik*, para aportar funciones de las que este último carece.

## Funciones

* Sustituye a Traefik (que actúa a nivel interno) como punto de entrada a los servicios web. Recibe peticiones para cualquier dominio, y las propaga para que sean resueltas por Traefik hacia los contenedores apropiados.

* Sirve a través de HTTPS todos los servicios, que funcionan sobre HTTP (o HTTPS si es necesario) localmente. Carga los certificados y los parámetros Diffie-Hellman con la ayuda de [certificates-manager](https://gitlab.com/redmic-project/gateway/certificates-manager).

* Comprime las respuestas a las peticiones con gzip, disminuyendo el tráfico de red.

* Protege frente al acceso malicioso, por parte de bots o desde orígenes sospechosos. Toma la información de [mariusv/nginx-badbot-blocker](https://github.com/mariusv/nginx-badbot-blocker) para ello.

## Volúmenes

Se definen diferentes volúmenes para lograr persistencia del servicio, al mismo tiempo que se mantienen separados ficheros de distinta índole.

### persistent-vol

Almacena aquellos ficheros que no son secretos y que interesa conservar entre reinicios del servicio, como los parámetros Diffie-Hellman. Se trata de un volumen externo al servicio.

## Configuraciones

Para poder contemplar varios casos de uso (según entorno de despliegue, por ejemplo) se definen configs de Docker, estáticas para el servicio pero que permiten mayor flexibilidad.

### default

Define los servers que darán el servicio.

### blockips

Contiene un listado de IP que deben bloquearse siempre. Procede originalmente de <https://github.com/mariusv/nginx-badbot-blocker/blob/master/blockips.conf>, pero es posible añadir más IP a la lista.

### blacklist

Define aquellos agentes (para identificar bots), dominios y URL que deben ser bloqueados. Procede originalmente de <https://github.com/mariusv/nginx-badbot-blocker/blob/master/blacklist.conf>, pero ha sido ampliado y es posible editarlo. Por ejemplo, para bloquear bots de rastreo o para conceder acceso a un agente concreto.

### block-requests

Aplica los bloqueos configurados desde blacklist.

### ssl-params

Provee los parámetros relativos al uso de certificados.

### ssl-certs

Provee la importación de los certificados para su uso.

### gzip

Mantiene una relación de extensiones a comprimir y los parámetros usados para ello.

## Secretos

Del mismo modo que con las configs, se usan secrets de Docker para almacenar aquellas configuraciones que además no deben ser públicas.

### cert-chain

Contenido del fichero `chain.pem` del certificado.

### cert-fullchain

Contenido del fichero `fullchain.pem` del certificado.

### cert-privkey

Contenido del fichero `privkey.pem` del certificado.
