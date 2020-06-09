#!/bin/bash

# 
# Programa realizado por José Rubén Daza Hernández para la 
# asignatura de Sistemas Informaticos (1ºCFGS Desarrollo Web).
# 
function menu_principal {
    # En este metodo se muestran las opciones y se recoge la opcion del usuario.

    echo ""
    echo "*************************************************"
    echo "                      Menú "
    echo "*************************************************"
    echo "1. Añadir alumnos."
    echo "2. Gestión de disco."
    echo "3. Mostrar procesos en ejecución."
    echo "4. Estado del sistema."
    echo "5. Añadir contenido."
    echo "6. Salir."
    echo "*************************************************"
    echo ""

    read -p ">> " opcion

    regla_menu='^[0-6]$'
    
    if [[ $opcion =~ $regla_menu ]]
    then
        #Si la opcion es correcta entramos al switch, sino, enviamos un mensaje de error.
        case $opcion in 
            1)
                #Esta opcion requiere que pertenezcas al grupo administradores.
                comprobar_permisos

                #Si tienes los permisos
                if [ $? = "1" ] 
                then
                    agregar_alumnos 
                else 
                    echo "¡No eres un administrador! >:(" 
                fi
            ;;
            2)
                #Esta opcion requiere que pertenezcas al grupo administradores.
                comprobar_permisos
                
                #Si tienes los permisos
                if [ $? = "1" ] 
                then
                    submenu_gestion_disco
                else
                    echo "¡No eres un administrador! >:(" 
                fi
            ;;
            3)
                ver_procesos
            ;;
            4)
                estado_del_sistema
            ;;
            5)
                agregar_contenido                
            ;;
            6)
                echo "¡Nos vemos!"
                salir=true
        esac
    else 
        echo "¡No has introducido una opcion valida!"
    fi
}

function comprobar_permisos {
    # Comprobamos los permisos: Consigo el nombre de usuario, se lo paso al comando
    # id y consigo sus grupos, y busco las lineas en las que coincide con "administradores".
    # Si hay 1 coincidencia, devuelvo 1, sino, devuelo 0.

    nombre_usuario=$(whoami)
    permisos=$(groups $nombre_usuario | grep -c administradores)
    if [ $permisos = 1 ]
    then
        return 1
    else 
        return 0
    fi
}

function agregar_alumnos {
    # En esta funcion vamos a agregar a un grupo de alumnos desde un archivo con el formato de
    # newusers(el comando que estoy usando).

    datos_correctos=false
    # Vamos a comprobar que los datos son correctos y cuando lo sean, dejara cumplir la condicion del while.
    while [ $datos_correctos == false ]
    do
    echo "Introduce la ruta del archivo (¡relativa o absoluta!)"
    read  -p ">> " ruta_usuario
        
        if [ -f $ruta_usuario ] && [ -s $ruta_usuario ]
        then 
            # Si la ruta es un archivo (no directorio) y no esta vacio.
            datos_correctos=true;
        else
            echo "La ruta o el archivo no es valido"
        fi
    done

    # agregamos los usuarios redireccionando los errores para que no se muestren en pantalla. 
    # Pedimos sudo en este punto para un comando en especifico para tener mayor control del superusuario.   
    sudo newusers $ruta_usuario 2> /dev/null
            
    if [ $? -eq 0 ]
    then 
        # Si el comando dio una salida: "0" (Sin errores)
        echo "¡Se han agregado los usuarios correctamente!"
    else
        echo "Hemos tenido un problemilla al agregar los usuarios (Comprueba que has puesto bien la contraseña, y que el archivo tiene el formato correcto)"
    fi

}

function submenu_gestion_disco {
    # En este metodo se muestra el submenu de la opcion 2 del menu principal.
    
    regla_submenu='^[0-4]$'
    submenu_salir=false

    while [ $submenu_salir = "false" ]
    do
        
        echo ""
        echo "*************************************************"
        echo "                      Menú "
        echo "*************************************************"
        echo "1. Consultar tamaño del directorio home."
        echo "2. Realizar copia de seguridad."
        echo "3. Listado de archivos grandes. (> 10mb)"
        echo "4. Volver al menu anterior."
        echo "*************************************************"
        echo ""

        read -p ">> " opcion_submenu

        if [[ $opcion_submenu =~ $regla_submenu ]]
        then
            case $opcion_submenu in 
                    1)
                    tamano_directorio_home
                    ;;
                    2)
                    backup_home
                    ;;
                    3)
                    listar_archivos_grandes
                    ;;
                    4)
                    submenu_salir=true
            esac
        else
            echo "¡No has introducido una opcion valida!"
        fi

    done
}

function tamano_directorio_home {
    # Con ~ decimos que calcule el tamaño de: /home/$USER
    echo "# Calculando #"
    du -sh ~
}

function backup_home {
    # Obtenemos la hora y comprobamos si existe la carpeta backups
    hora_actual=$(date +%d-%m-%y)
    if [ -d /backups ]
    then
        # Si existe comprimimos y redirigimos los errores para no verlos.
        echo "Comprimiendo... Puede tardar unos minutos."
        sudo tar -czf /backups/backup-$hora_actual ~  2>> /dev/null
    else 
        # Si no existe, la creamos y volvemos a llamar a esta misma funcion.
        echo "No existe la carpeta /backups. Estamos creadola"
        sudo mkdir /backups
        backup_home
    fi
}

function listar_archivos_grandes {
    usuario=$(whoami)
    # Buscar los archivos (no carpetas) de un tamaño mayor a 10 Megas y del usuario actual.
    find / -type f -size +10M -user $usuario
}

function ver_procesos {
    # En esta funcion de muestran los procesos del sistema 
    echo "***** PROCESOS DEL SISTEMA *****"
    
    # opcion -e = todos los procesos del sistema con sintaxis standards, -o formato de salida, 
    # en este caso, la columna pid y la llamamos PID y la columna CMD y le llamamos nombre.
    ps -e -o pid=PID,cmd=NOMBRE
}

function estado_del_sistema { 
    # Esta funcion trata de dar un vistazo general del sistema (tiempo de encendido, cpu, ram, hdd, etc..)  
    
    tiempo_encendido=$(uptime -p)
    # cantidad de usuarios: - who:  te muestra los usuarios,
    #                       - cut -f1 -d ' ':   corta el primer campo (f1) con el delimitador ' '
    #                       - wc -l:  cuenta el numero de lineas.
    #                       - sort -u: cuenta solo los unicos.
    cantidad_usuarios=$(who | cut -f1 -d ' ' | wc -l)
    cantidad_usuarios_reales=$(who | cut -f1 -d ' ' | sort -u | wc -l)
   
    echo "*****      DATOS BASICOS      *****"
    echo "Tiempo encendido: " $tiempo_encendido
    echo "Cantidad de usuarios conectados: " $cantidad_usuarios
    echo "Cantidad de usuarios distintos contectados: " $cantidad_usuarios_reales
    echo ""
    
    echo "***** INFORMACION DEL HDD *****"
    # Uso del disco en la particion donde se encuentre la raiz '/'
    df -h --output=source,used,avail /
    echo ""
    
    echo "***** INFORMACION DE LA RAM *****"
    # Tabla con el uso de la memoria principal y la memoria Swap (-th: totales y legible)
    free -th
    echo ""
    
    echo "***** INFORMACION DEL CPU *****"
    # Informacion del maximo, actual y minimo de hercios la CPU.
    lscpu | grep "CPU MHz"
    echo ""
    echo "********************************"
}

function agregar_contenido {

    datos_correctos=false
    # Vamos a comprobar que los datos son correctos y cuando lo sean, dejara cumplir la condicion del while.
    while [ $datos_correctos == false ]
    do
        echo "Introduce la ruta del archivo a añadir (¡recuerda, ruta absoluta!)"
        read  -p ">> " ruta_agregar
        echo "Introduce la ruta del archivo receptor (enserio. ruta absoluta.)"
        read  -p ">> " ruta_receptor
    
        # Si las rutas tienen como primer caracter la barra '\' y que el segundo y tercer carater no sean puntos. 
        if [[ ${ruta_agregar:0:1} == \/ && ${ruta_agregar:0:2} != \.\. && ${ruta_receptor:0:1} == \/ && ${ruta_receptor:0:2} != \.\. ]]
        then
            # Si son archivos (no directorios) y no esta vacio.
            if [[ -f $ruta_agregar && -s ${ruta_receptor} ]]
            then
                datos_correctos=true
            else
                echo "Las rutas de los archivos no son correctas."
            fi
        else
            echo "Introduce una ruta absoluta."
        fi    
    done
    
    # Para agregarlo lo abrimos con cat y redirigimos la salida estandar a un fichero (sin sobreescribir).
    cat $ruta_agregar >> $ruta_receptor 

}

# Bucle del menu principal que se para con la opcion 6. Ya que es una variable global.
salir=false

# No es recomendable ejecutar el script como root.
if [ $(whoami) = "root" ]
then
    echo "¡No me ejecutes como superusuario!"
else
    while [ $salir = false ] 
    do      
        menu_principal
    done
fi
