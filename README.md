# 🚀 launch-docker.ps1

Script en **PowerShell** para automatizar el proceso de **construcción, ejecución y despliegue de imágenes Docker**, con la opción de **subirlas automáticamente a AWS ECR**.

---

## 📘 Descripción

Este script simplifica el flujo de trabajo para desarrolladores que trabajan con Docker y AWS.  
Permite:

- Cargar variables de entorno desde archivos `.env`
- Construir imágenes Docker personalizadas
- Ejecutar contenedores localmente
- Autenticarse en AWS ECR y subir imágenes con un solo comando

---

## 🧠 Autor

**Luis Felipe Fernández**

---

## ⚙️ Parámetros

| Parámetro | Tipo | Descripción | Valor por defecto |
|------------|------|--------------|-------------------|
| `pushImage` | `boolean` | Indica si la imagen debe subirse a AWS ECR. | `0` (no subir) |
| `projectEnv` | `string` | Ruta al archivo `.env` con las variables del proyecto (nombre, versión, etc). | `./exampleProject.env` |
| `dockerLocalEnv` | `string` | Ruta al archivo `.env` con las variables de entorno locales usadas por Docker. | `./exampleDockerLocal.env` |

---

## 🧩 Archivos de entorno requeridos

### `exampleProject.env`
Contiene variables del proyecto necesarias para construir la imagen:

```bash
PROJECT_NAME=my-app
VERSION=1.0.0
AWS_REGION=us-east-1
CONTAINER_NAME=my-app-container
```
### `dockerLocalEnv.env`
Contiene variables usadas dentro del contenedor (por ejemplo, las del `application.yml` o `application.properties`):

```bash
SERVER_PORT=8000
SPRING_PROFILES_ACTIVE=local
DB_HOST=localhost
```

## 🧰 Modo de uso
### `Ejecutar en entorno local`
Para construir y ejecutar la imagen en tu máquina sin subirla a AWS:
.\launch-docker.ps1 -pushImage 0 -projectEnv "./devProject.env" -dockerLocalEnv "./local.env"

### `Subir imagen a AWS ECR`
Para construir la imagen y publicarla en tu repositorio ECR:
.\launch-docker.ps1 -pushImage 1 -projectEnv "./exampleProject.env"

##🧾 Licencia
Este script es de uso libre con fines educativos y profesionales.
Autoría: Luis Felipe Fernández



