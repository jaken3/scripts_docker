# 🚀 launch-docker.ps1

![PowerShell](https://shields.io)
![Docker](https://shields.io)
![AWS](https://shields.io)

Script en **PowerShell** diseñado para automatizar la **construcción, ejecución y despliegue** de imágenes Docker, con integración directa para **AWS ECR**.

---

## 📘 Descripción

Este script optimiza el flujo de trabajo entre Docker y AWS, permitiéndote:

*   **🔐 Gestión de variables:** Carga automática desde archivos `.env`.
*   **🛠️ Build automático:** Construcción de imágenes con tags personalizados.
*   **💻 Test local:** Ejecución inmediata de contenedores para pruebas.
*   **☁️ Cloud Ready:** Autenticación y subida (push) a AWS ECR en un solo paso.

---

## ⚙️ Parámetros


| Parámetro | Tipo | Icono | Descripción | Defecto |
| :--- | :--- | :---: | :--- | :--- |
| `pushImage` | `boolean` | 📤 | Indica si se sube a AWS ECR. | `0` |
| `projectEnv` | `string` | 📄 | Ruta al `.env` del proyecto (Tags, AWS Region). | `./exampleProject.env` |
| `dockerLocalEnv` | `string` | 🏠 | Ruta al `.env` para el runtime del contenedor. | `./exampleDockerLocal.env` |

---

## 🧩 Configuración de Entorno

### 1. `exampleProject.env` (Configuración del Build)
Variables necesarias para identificar la imagen y el destino en AWS:
```bash
PROJECT_NAME=my-app
VERSION=1.0.0
AWS_REGION=us-east-1
CONTAINER_NAME=my-app-container
```

### 2. `dockerLocalEnv.env` (Variables de Runtime)
Variables que vivirán **dentro** del contenedor:
```bash
SERVER_PORT=8000
SPRING_PROFILES_ACTIVE=local
DB_HOST=localhost
```

---

## 🏗️ Requisitos de Estructura

Para un funcionamiento óptimo, mantén la siguiente jerarquía de archivos:

*   ✅ **Dockerfile:** Debe estar en la raíz del proyecto.
*   ✅ **Carpeta `deploys`:** Ubicada al mismo nivel que `src`.

### 📂 Vista de Directorios
```text
root/
├── 📁 deploys/
│   ├── 📜 launch-docker.ps1
│   ├── 📄 devProject.env
│   └── 📄 local.env
├── 📁 src/
│   └── [Código fuente]
└── 🐳 Dockerfile
```

---

## 🧰 Modo de Uso

### 🛠️ Ejecución Local
Construye y levanta el contenedor sin subirlo a la nube:
```powershell
.\launch-docker.ps1 -pushImage 0 -projectEnv "./devProject.env" -dockerLocalEnv "./local.env"
```

### ☁️ Despliegue a AWS ECR
Construye y publica la imagen en tu repositorio de AWS:
```powershell
.\launch-docker.ps1 -pushImage 1 -projectEnv "./exampleProject.env"
```

---

## 🧠 Autor


| [![Luis Felipe Fernández](https://shields.io)](https://www.linkedin.com/in/luis-felipe-fernandez) |
| :--- |

---

## 🧾 Licencia
Este script es de **uso libre** con fines educativos y profesionales.  
Desarrollado por: **Luis Felipe Fernández**
