# Automatización de despliegues en entornos Cloud

Proyecto Terrafom, para el despliegue de la infraestructura en Azure, Ansible para el despliegue de la instalación automatizada de un clúster Kubernetes Linux CentOs 8, y Ansible para el despliegue de una aplicaión NGINX con una web HTML de prueba.

## Requerimientos Iniciales
Para poder ejecutar el proyecto es necesario hacerlo desde un equipos con Linux y una cuenta de Azure.

## Terraform-Azure
### Diagrama de la infraestructura a desplegar:
![diagrama de red](https://github.com/juanmaorgaz/devopscp2/blob/main/terraform.png?raw=true)

### Archivos a personalizar
#### Cambiar el fichero de parámetros de Azure correccion-vars.tf
```
provider "azurerm" { 
  features {} 
  subscription_id = "<SUBSCRIPTION_ID>" 
  client_id       = "<APP_ID>"        # se obtiene al crear el service principal 
  client_secret   = "<CLIENT_SECRET>" # se obtiene al crear el service principal 
  tenant_id       = "<TENANT_ID>"     # se obtiene al crear el service principal 
}
```
#### Cambiar el fichero de variables correccion-vars.tf
```
variable "location" {
  type = string
  description = "Región de Azure donde crearemos la infraestructura"
  default = "West Europe"
}

variable "storage_account" {
  type = string
  description = "Nombre para la storage account"
  default = "storageaccountcp2"
}

variable "public_key_path" {
  type = string
  description = "Ruta para la clave pública de acceso a las instancias"
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_user" {
  type = string
  description = "Usuario para hacer ssh"
  default = "adminUsername"
}
```
