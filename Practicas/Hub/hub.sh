#!/bin/bash

function get() {
    ip="$1"
    community="$2"
    segment=$(($3 + 1000))

    output="$(snmpget -v 1 -c "$community" "$ip" ".1.3.6.1.4.1.43.10.26.1.1.1.5.1.$segment")"
    echo "$output" | rev | cut -d' ' -f1 | rev
    return $?
}

function set() {
    ip="$1"
    community="$2"
    port="$3"
    value="$4"

    snmpset -v 1 -c "$community" "$ip" ".1.3.6.1.4.1.43.10.26.1.1.1.5.1.$port" i $value
    return $?
}

function walk() {
    ip="$1"
    community="$2"

    snmpwalk -v 1 -c "$community" "$ip" .1.3.6.1.4.1.43.10.26.1.1.1.5
    return $?
}

function appearances() {
    list="$1"
    value="$2"

    echo "$list" | grep -c '^'"$value"'$'
}

function process_file() {
    file="$1"

    ip_count=$(grep -c '^ip ' "$file")
    community_count=$(grep -c '^community ' "$file")
    default_segment_count=$(grep -c '^default ' "$file")

    # Verificar si alguna variable se encuentra más de una vez
    if [ "$ip_count" -gt 1 ]; then
        echo "Error: La variable 'ip' se encuentra definida más de una vez."
        return
    fi

    if [ "$community_count" -gt 1 ]; then
        echo "Error: La variable 'community' se encuentra definida más de una vez."
        return
    fi

    if [ "$default_segment_count" -gt 1 ]; then
        echo "Error: La variable 'default' se encuentra definida más de una vez."
        return
    fi

    # Extraer variables presentes una vez
    ip=$(sed -n '/^ip/{s/^ip \([^ ]*\).*/\1/p;q}' "$file")
    community=$(sed -n '/^community/{s/^community \([^ ]*\).*/\1/p;q}' "$file")
    default_segment=$(sed -n '/^default/{s/^default \([^ ]*\).*/\1/p;q}' "$file")

    # Extraer listas de puertos y segmentos
    port_list=$(sed -n '/^port/s/^port \([^ ]*\) segment \([^ ]*\).*/\1/p' "$file")
    port_array=($port_list)

    segment_list=$(sed -n '/^port/s/^port \([^ ]*\) segment \([^ ]*\).*/\2/p' "$file")
    segment_array=($segment_list)

    available_port_list=$(walk "$ip" "$community")
    # No hay que hacer la asignación en la condición porque se pierde la visibilidad de la variable
    if [ $? -ne 0 ]; then 
        echo "Error: No se ha podido establecer conexión con el hub."
        return
    fi

    available_port_list=$(echo "$available_port_list" | sed -nE 's/.*\.([0-9]+) = INTEGER: ([0-9]+)/\1/p')

    function is_port() { [ $(appearances "$available_port_list" "$1") -gt 0 ]; return $?; }
    function is_segment() { [ $(appearances "$available_port_list" $(($1 + 1000))) -gt 0 ]; return $?; }

    # Asignación puerto-segmento en paralelo
    for ((i = 0; i < ${#segment_array[@]}; i+=1)); do
    {
        port="${port_array[i]}"
        segment="${segment_array[i]}"

        if ! is_port "$port"; then
            echo "Error: $port no es un puerto disponible de este hub." >&2
            return; #¡¡¡¡continue si no se lanza en paralelo!!!!
        fi

        if ! is_segment "$segment"; then
            echo "Error: $segment no es un segmento disponible de este hub." >&2
            return;
        fi
        
        if [ $(appearances "$port_list" "$port") -eq 1 ]; then
            value=$(get "$ip" "$community" "$segment")
            set "$ip" "$community" "$port" "$value"
        fi
    } & # Cada puerto en paralelo
    done

    # Asignación del segmento default al resto de puertos
    if [ "$default_segment" = "" ]; then
        wait
        return
    fi

    if is_segment $default_segment; then
        value=$(get "$ip" "$community" "$default_segment")

        echo "$available_port_list" | while read -r port; do
        {
            if [ $port -lt 1000 ] && [ $(appearances "$port_list" "$port") -ne 1 ]; then
                set "$ip" "$community" "$port" "$value"
            fi
        } & # Cada puerto en paralelo
        done
    else
        echo "Error: $default_segment no es un segmento disponible de este hub." >&2
    fi

    wait
}

if ! command -v snmpwalk &> /dev/null; then
    echo "Error: El sistema no tiene habilitada la herramienta snmp." >&2
    echo "      yum install net-snmp-utils" >&2
    echo "      apt install snmp" >&2
    exit 1
fi

# Verificar si se proporcionan argumentos
if [ "$#" -eq 0 ]; then
    echo "Uso: $0 [ FILE | DIR ]..." >&2
    exit 1
fi

# Recorrer cada argumento
for item in "$@"; do
    if [ -f "$item" ]; then
        # Si el argumento es un fichero lo toma como fichero de configuración
        echo "Procesando fichero: $item"
        process_file "$item" & # Ejecución en segundo plano
    elif [ -d "$item" ]; then
        # Si el argumento es un directorio, busca ficheros .hub dentro de él
        for file in "$item"/*.hub; do
            if [ -f "$file" ]; then
                echo "Procesando archivo: $file"
                process_file "$file" & # Ejecución en segundo plano
            else
                echo "Advertencia: No se encontraron ficheros .hub en el directorio $item." >&2
            fi
        done
    else
        echo "Error: $item no es un fichero ni un directorio válido." >&2
    fi
done

# Esperar a que todos los procesos en segundo plano terminen
wait
