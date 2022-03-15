# Automatización de despliegues en entornos Cloud

Proyecto Terrafom, para el despliegue de la infraestructura en Azure, Ansible para el despliegue de la instalación automatizada de un clúster Kubernetes Linux CentOs 8, y Ansible para el despliegue de una aplicaión NGINX con una web HTML de prueba.

## Requerimientos Iniciales
Para poder ejecutar el proyecto es necesario hacerlo desde un equipos con Linux (con terraform y ansible instalado) y una cuenta de Azure.

## Terraform-Azure
### Diagrama de la infraestructura a desplegar:
![Terraform](https://github.com/juanmaorgaz/devopscp2/blob/main/terraform.png?raw=true)

### Archivos a personalizar
#### Cambiar el fichero de parámetros de Azure credentials.tf
```
provider "azurerm" { 
  features {} 
  subscription_id = "<SUBSCRIPTION_ID>" 
  client_id       = "<APP_ID>"        # se obtiene al crear el service principal 
  client_secret   = "<CLIENT_SECRET>" # se obtiene al crear el service principal 
  tenant_id       = "<TENANT_ID>"     # se obtiene al crear el service principal 
}
```
Personalice los datos:
- **subscription_id**: Id de subscripción de MS Azure.
- **client_id**, **client_secret** y **tenant_id**: Estos valores se obtienen al crear el Service Principal en MS Azure.

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
  default = "~/.ssh/id_rsa.pub" # o la ruta correspondiente de la clave ssh
}
variable "ssh_user" {
  type = string
  description = "Usuario para hacer ssh"
  default = "adminUsername"
}
```
Personalice las variables con sus datos y rutas.

### Pasos para el Despliegue
- Clonar el proyecto.
- Entrar a la carpeta ansible `cd terraform`
- Editar los archivos según lo indicado anteriormente.
- Realizar el despliegue con Terraform:
```bash
terraform init
terraform apply
```

## Despliegue con Ansible

### Diagrama de Red
![Kubernetes](https://github.com/juanmaorgaz/devopscp2/blob/main/cluster.png?raw=true)

### Archivos a personalizar
#### Archivo hosts
```
[all:vars] 
ansible_user==<<USER>> 

[master] 
kubemaster.dominio.es ansible_host=<<IP_MASTER>> 

[workers] 
kubenode1.dominio.es ansible_host=<<IP_WORKER1>> 

[nfs] 
nfs.dominio.es ansible_host= <<IP_NFS>> 
```
Personalice los datos:
- Variable **ansible_user**: Usuario Linux con el cual Ansible se conectará a los servidores master, workers y nfs.
- Variable **kubexxx.dominio.es**: Nombre de cada uno de los servidores master, workers y nfs.
- Variables **ansible_host=**: IPs para conectar a los servidores master, workers y nfs.

### Pasos para el Despliegue
- Clonar el proyecto.
- Entrar a la carpeta ansible `cd ansible`
- Editar los archivos según lo indicado anteriormente.
- Para los hosts (master, workers y nfs), el usuario a usar debe estar configurado para realizar el escalado de privilegios y con las llaves de autenticación ssh.
- Lanzar ambos playbooks ejecutando el archivo bash **deploy.sh**
 - **(Opcional)** Ejecutar por separado el playbook de despliegue de Kubernetes:
```bash
ansible-playbook -i hosts 00-despliegue-kubernetes.yaml
```
 - **(Opcional)** Ejecutar por separado el playbook de despliegue de las aplicaciones de ejemplo:
```bash
ansible-playbook -i hosts 00-despliegue-aplicacion.yaml
```
