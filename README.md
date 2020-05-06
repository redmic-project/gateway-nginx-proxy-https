# Nginx proxy HTTPS

Nginx service configured to act as a proxy to Traefik service. Add caching and bot protection capabilities

Este servicio sirve de proxy inverso al frente de *Traefik*, para aportar funciones de las que este último carece.

## Funciones

* Sustituye a Traefik (que actúa a nivel interno) como punto de entrada a los servicios web. Recibe peticiones para cualquier dominio, y las propaga para que sean resueltas por Traefik hacia los contenedores apropiados.

* Sirve a través de HTTPS todos los servicios, que funcionan sobre HTTP localmente. Carga los certificados con la ayuda de [certificates-manager](https://gitlab.com/redmic-project/gateway/certificates-manager) y genera sus propios parámetros Diffie-Hellman cuando no los tiene disponibles (normalmente solo la primera vez, hay que tener paciencia porque es un proceso pesado).

* Comprime las respuestas a las peticiones con gzip, disminuyendo el tráfico de red.

* Implementa un mecanismo de caché, configurable por subdominios, rutas, cabeceras, etc. Ayuda a reducir la carga de los servicios, devolviendo directamente respuestas que ya se han devuelto recientemente.

* Protege frente al acceso malicioso, por parte de bots o desde orígenes sospechosos. Toma la información de [mariusv/nginx-badbot-blocker](https://github.com/mariusv/nginx-badbot-blocker) para ello.

## Variables

Se pueden definir algunos valores variables al servicio web.

| Variable | Descripción | Valor por defecto |
|:-:|:-:|:-:|
| PERSISTENT_PATH | Ruta interna al contenedor sobre la que se montará el volumen `persistent-vol`. | `/var/nginx/persistent` |

## Volúmenes

Se definen diferentes volúmenes para lograr persistencia del servicio, al mismo tiempo que se mantienen separados ficheros de distinta índole.

### persistent-vol

Almacena aquellos ficheros que no son secretos y que interesa conservar entre reinicios del servicio. Por ejemplo, los parámetros Diffie-Hellman.

### cache-vol

Conserva los ficheros de caché generados durante el funcionamiento del servidor web. Para limpiar la caché, es posible reiniciar el servicio tras borrar este volumen, y se volverá a regenerar de nuevo sin inconvenientes.

## Configuraciones

Para poder contemplar varios casos de uso (según entorno de despliegue, por ejemplo) se definen configs de Docker, estáticas para el servicio pero que permiten mayor flexibilidad.

### blockips

Contiene un listado de IP que deben bloquearse siempre. Procede originalmente de <https://github.com/mariusv/nginx-badbot-blocker/blob/master/blockips.conf>, pero es posible añadir más IP a la lista.

### blacklist

Define aquellos agentes (para identificar bots), dominios y URL que deben ser bloqueados. Procede originalmente de <https://github.com/mariusv/nginx-badbot-blocker/blob/master/blacklist.conf>, pero ha sido ampliado y es posible editarlo. Por ejemplo, para bloquear bots de rastreo o para conceder acceso a un agente concreto.

## Secretos

Del mismo modo que con las configs, se usan secrets de Docker para almacenar aquellas configuraciones que además no deben ser públicas.

### cert-chain

Contenido del fichero `chain.pem` del certificado.

### cert-fullchain

Contenido del fichero `fullchain.pem` del certificado.

### cert-privkey

Contenido del fichero `privkey.pem` del certificado.
