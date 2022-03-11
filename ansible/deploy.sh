#!/bin/bash

# Despliegue de Kubernetes
ansible-playbook -i hosts despliegue-kubernetes.yaml

# Despliegue de la aplicación
ansible-playbook -i hosts despliegue-aplicacion.yaml