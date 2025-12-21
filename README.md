# Prueba Técnica DevOps – Kambista

Este repositorio contiene la implementación de una solución DevOps end-to-end en GCP que cubre:

-Infraestructura como Código con Terraform
-Despliegue de un microservicio en Google Kubernetes Engine (GKE)
-Pipeline de CI/CD con GitHub Actions
-Seguridad basada en principio de menor privilegio
-Autenticación sin llaves mediante Workload Identity Federation
-Observabilidad básica con Cloud Logging


Flujo: 

GitHub (push)
   ↓
GitHub Actions (CI/CD)
   ↓
Artifact Registry (imagen Docker)
   ↓
GKE (Deployment + Service)
   ↓
LoadBalancer (endpoint público)


La infraestructura se despliega con el comando 

# terraform apply


# Seguridad e IAM

1). Service Account de CI/CD

Service Account:
sa-gha-kambista@devops-retotecnico-kambista.iam.gserviceaccount.com

Usado por GitHub Actions mediante OIDC, sin llaves JSON.

Roles utilizados:

roles/artifactregistry.writer           Permite subir imagenes docker al repositorio
roles/container.clusterViewer           Permite leer(Permisos Lectura) al cluster
roles/container.developer               Permite desplegar y actualizar en GKE
roles/logging.logWriter                 Permite registrar auditoría de despliegues

2). Service Account de nodos (GKE)

Service Account:
$ 548180225580-compute@developer.gserviceaccount.com

Usado por los nodos de GKE para descargar imágenes (pull)

Roles utilizados:

Permite a los nodos descargar imágenes


# Logs y Trazabilidad 

Para ver logs desde kubernetes 

    kubectl logs -n kambista-dev -l app=hello

O tambien podemos verlos desde GCP --> Logging --> Logs Explorer



# Configuracion Multi Entorno 

Para realizar la configuraciond e distintos ambientes estas serian la estructura que usaria:

infra/
  envs/
    dev/
    staging/
    prod/

Cada ambiente con su archivo .tfvars definiendo sus variables

Y para CI\CD utilizaria el flujo branch-based y declarando secretos separados por ambiente.

develop 
main
staging


