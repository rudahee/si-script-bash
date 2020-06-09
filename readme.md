# Proyecto
 
 **Para la asignatura de Sistemas Informaticos**
 
Es necesario tener instalado vagrant para usar el script de la carpeta vagrant.

### General

Este script se debe ejecutar SIN PERMISOS DE SUPERUSUARIO. cuando sea necesario te pedira la elevacion de privilegios.

si se quiere saltar la comprobacion del grupo se debe editar la linea 83

Orginal:
```bash
  return 0
```

Modificado:
```bash
  return 1
```

### Ejercicio 1

Es necesario pertenecer al grupo "administradores" y poder acceder a la elevacion de privilegios.

El formato del archivo de texto debe ser el siguiente:

~~~bash
nombre:clave:id_usuario:id_grupo:comentario:directorio_home:shell_default
~~~

la ruta puede ser absoluta o relativa **desde la carpeta de ejecucion del script.**

### Ejercicio 2

Para acceder al menu es necesario al grupo "administradores"

#### Ejercicio 2.2

Puede tardar mucho tiempo en realizar el backup del todo el directorio home del usuario. Es necesaria la elevacion de privilegios.
