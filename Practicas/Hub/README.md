# Trabajo de gestión de un hub

|**Autores**             |**NIP** | 
|:-----------------------|:-------|
| Toral Pallás, Héctor   | 798095 |
| Lahoz Bernad, Fernando | 800989 |
| Martínez Lahoz, Sergio | 801621 |

El fichero `hub.sh` es un script de configuración de hubs que permite asociar
los diferentes segmentos a cada uno de los puertos, mediante ficheros de texto
decalarativos. El script recibe como argumentos de entrada una lista de ficheros
y directorios. Si el argumento es un fichero lo leerá y realizará la configuración
que se detalle en él. Si el argumento es un directorio, leerá en él todos los
ficheros con extension `.hub`.

```shell
./hub.sh [DIR|FILE]...
```

Los ficheros de configuración tienen el siguiente aspecto:

```
ip <ip>
community <comm>

port <p1> segment <s1>
...
port <pN> segment <sN>

default <segment>
```

En el fichero `example.hub` aparece un ejemplo de configuración y se explica más 
detalladamente las consideraciones que hay que tener para su correcto uso.