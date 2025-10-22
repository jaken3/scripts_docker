<#
    Script: launch-docker.ps1
    Description: Ejecuta docker y permite subir la imagen a AWS
    Author Luis Felipe Fernandez
#>

<#
    @param pushImage: true si requieres subir la imagen a AWS
    @param projectEnv: Variables de entorno requeridas para contruir el docker ver example.env 
    @param dockerLocalEnv: Variables de entorno que se usan en el proyecto (application.yml o application.properties). 
        Estas se integran a la imagen para verificar su comportamiento en entornos locales.
#>
param(
    [boolean] $pushImage = 0,
    [string] $projectEnv = "./exampleProject.env",
    [string] $dockerLocalEnv = "./exampleDockerLocal.env"

)

# Cargar variables desde el archivo .env

if (-not (Test-Path $dockerLocalEnv)) {
    Write-Host "Archivo de entorno local no encontrado: $dockerLocalEnv" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $projectEnv)) {
    Write-Host "Archivo de entorno de proyecto no encontrado: $projectEnv" -ForegroundColor Red
    exit 1
}

Write-Host " ***  Cargando variables desde archivo... *** " -ForegroundColor DarkCyan
Get-Content $projectEnv | ForEach-Object {
    if ($_ -match '^\s*(\w+)\s*=\s*(.+?)\s*$') {
        $key = $matches[1]
        $value = $matches[2]
        [System.Environment]::SetEnvironmentVariable($key, $value)
    }
}
if ($pushImage) {
    # Obtener el ID de la cuenta amazon, previamente configurado
    Write-Host " *** Obteniendo ID de cuenta AWS... *** " -ForegroundColor DarkGreen
    $accountId = aws sts get-caller-identity --query Account --output text
    if (-not $accountId) {
        Write-Host "** auth-aws: No se pudo obtener el ID de la cuenta **" -ForegroundColor Red
        exit 1
    }

    Write-Host " *** Autenticando en ECR ... ***" -ForegroundColor DarkGreen
    if (-not $env:AWS_REGION) {
        Write-Host "Variable AWS_REGION no definida en el entorno" -ForegroundColor Red
        exit 1
    }
    aws ecr get-login-password --region $env:AWS_REGION | docker login --username AWS --password-stdin "$accountId.dkr.ecr.$($env:AWS_REGION).amazon.com"
}

Write-Host " *** Iniciando dockerizacion *** " -ForegroundColor DarkCyan
# Nombre de la imagen a construir 
if (-not $env:PROJECT_NAME -or -not $env:VERSION) {
    Write-Host "Faltan variables PROJECT_NAME o VERSION" -ForegroundColor Red
    exit 1
}
$imageName = "$($env:PROJECT_NAME):$($env:VERSION)"

# Buscar contenedores que usan la imagen 
$containers = docker ps -a --filter "ancestor=$imageName" --format "{{.ID}}"

# Detener y eliminar contenedores previos si existen 
if ($containers) {
    Write-Host "*** Deteniendo contenedores que usan $imageName ***" -ForegroundColor DarkGreen
    docker stop $containers
    Write-Host "*** Eliminando contenedores $containers ***" -ForegroundColor DarkGreen
    docker rm $containers
}

# Eliminar imagen previa si exitste
if (docker images -q $imageName) {
    Write-Host "*** Eliminando imagen $imageName ***" -ForegroundColor DarkGreen
    docker rmi -f $imageName
}

# Construir imagen de docker
Write-Host "*** Contruyendo Imagen Docker ***" -ForegroundColor Cyan

# contruye la imagen docker con un puerto dinamico
docker build -f ../Dockerfile -t $imageName .. --no-cache

if ($pushImage) {
    Write-Host "*** Subiendo imagen a ECR ***" -ForegroundColor Magenta
    docker push $imageName
    Write-Host "*** Imagen subida con satisfactoriamente ***" -ForegroundColor DarkMagenta
}
else {
    Write-Host "*** Iniciando en local ***" -ForegroundColor Yellow
   
    # Importante: asegúrate de que EXPOSE (DockerFile) y SERVER_PORT (dockerLocalEnv) estén sincronizados.
    # Esto garantiza que el puerto expuesto por Docker coincida con el puerto en el que la aplicación escucha dentro del contenedor.
    docker run -d -p  8000:8000 --env-file $dockerLocalEnv --name "$env:CONTAINER_NAME" $imageName
    Write-Host "*** Imagen iniciada satisfactoriamente ***" -ForegroundColor Magenta
}

