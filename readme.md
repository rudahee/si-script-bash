# Proyecto SI

---

## Indice

1. [Descripcion](#descripcion)
2. [Preparacion del entorno](#preparacion-del-entorno)
3. [Antes de empezar](#informacion-importante)
4. [Uso](#uso-del-script)


---

## Descripcion

Proyecto para la asignatura de Sistemas Informaticos del primer curso de *CFGS Desarrollo de Aplicaciones Web*. El enunciado se puede encontrar [aqui.](https://drive.google.com/file/d/1nc60ywP2WoOJIy-oEWAmcpuCY-P8Plwb/view?usp=sharing)

## Preparacion del entorno

**A tener en cuenta:**

- **Es necesario usar Linux.** Esta desarrollado en Arch Linux, pero deberia ser compatible con cualquier distribucion.
  
- Es necesaria una cuenta con acceso a superusuario y que pertenezca al grupo `administradores`.

- Recomiendo usar los archivos de la carpeta *recursos* al ejecutar las distintas opciones del script.

- Es **recomendable** hacer pruebas sobre un sistema limpio

#### Usando Vagrant

vamos a ejecutar esta secuencia de comandos (O usar el archivo vangrant-install.sh de la carpeta vagrant **Sin superusuario**)

```sh
vagrant init archlinux/archlinux
vagrant up
```

Para iniciar la conexion con la maquina virtual se usa: `vagrant ssh`
Para subir un archivo a la maquina virtual se usa: `vagrant upload`

Recomiendo subir el Script, y toda la carpeta recursos.

Una vez estemos dentro de la maquina virtual y con el script y la carpeta recursos, podremos empezar a probar con ella.

## Informacion importante

El script se debe ejecutar **SIN PERMISOS DE SUPERUSUARIO**. cuando sea necesario te pedira la elevacion de privilegios.

Se puede saltar la comprobacion del grupo. Se debe editar la linea 83

Orginal:
```bash
  return 0
```

Modificado:
```bash
  return 1
```

## Uso del script

- #### Ejercicio 1

Es necesario pertenecer al grupo "administradores" y poder acceder a la elevacion de privilegios.

El formato del archivo de texto debe ser el siguiente:

```bash
nombre:clave:id_usuario:id_grupo:comentario:directorio_home:shell_default
```

la ruta puede ser absoluta o relativa **desde la carpeta de ejecucion del script.**

- #### Ejercicio 2

Para acceder al menu es necesario al grupo "administradores"

- ##### Ejercicio 2.2

Puede tardar mucho tiempo en realizar el backup del todo el directorio home del usuario. Es necesaria la elevacion de privilegios.

- #### Ejercicio 5

Las rutas deben ser absolutas obligatoriamente.