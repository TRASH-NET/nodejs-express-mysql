# Node.js Rest APIs with Express & MySQL example by [bezkoder](https://github.com/bezkoder/nodejs-express-mysql)

El proyecto consta de una API Web en Node.js la cual interactúa con una base de datos MySQL. La aplicación debe ser desplegada en un App Service de Azure el cual requiere de la configuración de un App Service Plan (servicio que da el soporte de infraestructura a la aplicación).
![project_architecture](/img/project_architecture.png)

## Paso 1. Crear claves SSH
Creamos el par de claves utilizando el comando
```
ssh-keygen -t rsa
```
![ssh_key](/img/ssh_key_1.png)
### Paso 1.1 Inicializar el agente SSH y agregar las claves
Añadimos el par de claves creadas utilizando en agente SSH con los comandos
```
eval "$(ssh-agent -s)"
ssh-add .ssh/id_rsa
```
![ssh_key](/img/ssh_key_2.png)

## Paso 2. Crear el archivo de variables de terraform en el directorio de la maquina virtual (vm)
Este archivo deberá ser llamado ```terraform.tfvars``` y deberá estar dentro de la carpeta ```terraform```
```
location = "eastus"
ssh_key_path = "~/.ssh/id_rsa.pub"
tenant_id ="xxx-xxx-xxxxxx-xxxxx"
subscription_id ="xxx-xxx-xxxxxx-xxxxx"
client_secret="xxx-xxx-xxxxxx-xxxxx"
client_id="xxx-xxx-xxxxxx-xxxxx"

```
Nota: Se utilizo Azure CLI.

## Paso 3. Crear archivo principal de terraform para la máquina virtual
Este archivo se encuentra en la carpeta de este repositorio con el nombre [main.tf](/terraform/vm/main.tf) dentro de la carpeta ```terraform/vm/``` y se ejecuto el comando. ```terraform init``` para inicializar el proyecto. y luego ```terraform apply --auto-approve``` para crear la máquina virtual en Azure.
En este se podrán encontrar la instrucciones necesarias para crear la máquina virtual en Azure.


## Paso 4. Crear variables de entorno para el app service (app_service)
```
location = "eastus"
ssh_key_path = "~/.ssh/id_rsa.pub"
```
## Paso 5. Crear archivo principal de terraform para el app service
Este archivo se encuentra en la carpeta de este repositorio con el nombre [main.tf](/terraform/app_service/main.tf) dentro de la carpeta ```terraform/app_service/``` y se ejecuto el comando. ```terraform init``` para inicializar el proyecto. y luego ```terraform apply --auto-approve``` para crear el app service
En este se podrán encontrar la instrucciones necesarias para crear el app service en Azure.

## Paso 6. Crear script de Ansible
En el archivo [userdata.sh](/terraform/vm/userdata.sh) se puede encontrar el script que tiene un listado de comandos que se ejecutarán en la máquina instanciada para poder instalar ansible y posteriormente MySQL con el [playbook de ansible](/ansible/mysql.yml).

## Paso 6. Prepara secrets para el pipeline dentro de GitHub Actions
Para esto nos dirigimos a la configuración del repositorio y en la sección de seguridad desplegaremos el menú "Secrets and Variables" y posteriormente la opción "Actions". Allí podremos añadir una nueva secret con el nombre "AZURE_CREDENTIALS". En el valor podremos ingresar los valores de las credenciales de Azure necesarias las cuales son las que se encuentra en el archivo [terraform.tfvars](/terraform/vm/terraform.tfvars).
![secrets](/img/github_actions_secrets.png)
Se pueden ingresar con formato JSON de la siguiente manera:
```JSON
{
    "clientId": "XXXX",
    "clientSecret": "XXXX",
    "subscriptionId": "XXXX",
    "tenantId": "XXXX"
}
```

## Paso 7. Crear el pipeline de GitHub actions
Este [pipeline](/.github/workflows/node.js.yml) nos permitirá enviar los cambios que se hagan dentro de la rama main hacía el app service para que se suban los cambios automáticamente.


# Integrantes
- Emmanuel Silva Diaz - T00055599
- Alessandro Ramirez Miranda - T00065367
- Alex David Gutierrez Puello - T00064365
- Julian Camacho - T00059816