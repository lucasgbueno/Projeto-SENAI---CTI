# Infraestrutura Multicloud com Terraform e Kubernetes

Este repositório contém a configuração necessária para criar clusters Kubernetes na AWS e Azure, além de configurar uma VPN entre as duas plataformas utilizando Terraform. A pasta `K8S` contém a configuração do Kubernetes, e a pasta `Terraform` contém os arquivos para provisionar os recursos na AWS e Azure.

## Estrutura do Repositório

## **Terraform**
#### **Terraform/AWS**
1. **eks.tf**
   - Código Terraform para:
     - Criar o EKS (Elastic Kubernetes Service)
     - Criar os nós (nodes).
     - Adicionar os complementos (kube-proxy, vpc-cni, pod-identity, ebs-csi, coredns)
     - Configurar as regras no grupo de segurança criado por padrão ao configurar o EKS.

2. **outputs.tf**
   - Output do ID do grupo de segurança criado automaticamente pelo EKS para mudar as regras.
   - Outputs da VPN AWS para exportação de dados ao módulo Azure, permitindo a configuração da VPN entre AWS e Azure.

3. **variables.tf**
   - Definição das variáveis modificáveis, como:
     - Nome do recurso.
     - CIDR.
     - Tamanho da instância.
     - Capacidade de armazenamento das instâncias.

4. **vpc.tf**
   - Código para criar a infraestrutura da VPC, incluindo:
     - VPC.
     - Internet Gateway.
     - Tabelas de rotas.
     - Sub-redes.
     - Grupos de segurança.

5. **vpn.tf**
   - Código para configurar a VPN entre AWS e Azure.

---

#### **Terraform/AZURE**
1. **aks.tf**
   - Código Terraform para:
     - Criar o AKS (Azure Kubernetes Service)
     - Criar os nós (nodes).

2. **outputs.tf**
   - Outputs da VPN Azure para exportação ao módulo AWS, permitindo a configuração da VPN entre Azure e AWS.

3. **variables.tf**
   - Definição das variáveis modificáveis, como:
     - Nome do recurso.
     - CIDR.
     - Tamanho da instância.
     - Capacidade de armazenamento das instâncias.

4. **vnet.tf**
   - Código para criar a infraestrutura da VNET (Virtual Network), incluindo:
     - Grupo de recursos.
     - VNET.
     - Sub-redes.
     - Grupos de segurança.
     - Tabelas de rotas.


5. **vpn.tf**
   - Código para configurar a VPN entre Azure e AWS.

---

## **Kubernetes (K8S)**
#### **K8S/AWS**
1. **cluster-configuration.yaml**
   - Arquivo de configuração para hospedar como host o **KubeSphere** no cluster Kubernetes.

2. **ingress-site.yaml**
   - Configuração do **Ingress NGINX** para redirecionar o tráfego de entrada para os pods e portas configuradas.

3. **kubesphere-installer.yaml**
   - Arquivo de instalação dos recursos básicos necessários para o funcionamento do **KubeSphere**.

4. **letsencrypt.yaml**
   - Configuração do **Let's Encrypt** para gerar os certificados **TLS/SSL**.

---

#### **K8S/AZURE**
1. **cluster-configuration.yaml**
   - Arquivo de configuração para hospedar como membro o **KubeSphere** no cluster Kubernetes.

2. **ingress-site.yaml**
   - Configuração do **Ingress NGINX** para redirecionar o tráfego de entrada para os pods e portas configuradas.

3. **kubesphere-installer.yaml**
   - Arquivo de instalação dos recursos básicos necessários para o funcionamento do **KubeSphere**.


---

## Como Aplicar o codigo do Terraform nos provedores AWS e AZURE

1. **Configuração das credencias AWS**
    - Va ate o seu laboratorio ou conta e pegue as suas credenciais e adicione no arquivo de credentials do aws CLI.

2. **Configuração das credencias AZURE**
    - Execute o comando abaixo para fazer login na azure e vincular sua conta.
    ```bash
    az login
    ```

3. **Configuração AWS**
   - Navegue até a pasta `Terraform/AWS` e altere os valores necessários no arquivo `variables.tf`.

4. **Configuração AZURE**
    - Navegue até a pasta `Terraform/AZURE` e altere os valores necessários no arquivo `variables.tf`.

5. **Aplicar os codigos do terraform na aws e azure**
   - Execute os comandos Terraform para aplicar as configurações e criar as 2 infraestruturas.

   ```bash
   terraform init
   terraform apply --auto-approve
   ```

6. **Remover os recursos criados pelo codigo terrafom na aws e azure**
    - Execute o comando Terraform para destruir os recursos e configurações das aws e azure.

    ```bash
   terraform destroy --auto-approve
   ```