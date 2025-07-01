# Task 2 - SimpleTimeService Infrastructure

## Infrastructure Overview

### Network Configuration (No Overlapping) ✅
- **VNet**: 10.0.0.0/16 (65,536 IPs)
- **Public Subnet 1**: 10.0.1.0/24 (256 IPs) - Load Balancer
- **Public Subnet 2**: 10.0.2.0/24 (256 IPs) - Available
- **Private Subnet 1**: 10.0.10.0/24 (256 IPs) - AKS Nodes
- **Private Subnet 2**: 10.0.11.0/24 (256 IPs) - Available
- **Container Apps Subnet**: 10.0.20.0/23 (512 IPs) - Meets /23 requirement ✅

### Backend State Configuration ✅
- **Storage Account**: ststerraformstate001
- **Container**: tfstate
- **Resource Group**: terraform-state-rg

## Quick Deploy

### 1. Setup Backend
```bash
# Create backend storage
az group create --name terraform-state-rg --location "East US"
az storage account create --name ststerraformstate001 --resource-group terraform-state-rg --location "East US" --sku Standard_LRS
az storage container create --name tfstate --account-name ststerraformstate001
```

### 2. Deploy
```bash
terraform init
terraform apply -auto-approve
```

### 3. Deploy to AKS
```bash
# Get credentials
az aks get-credentials --resource-group sts-rg --name sts-aks

# Deploy app
kubectl create deployment sts-deployment --image=samar2608/simpletimeservice:latest
kubectl expose deployment sts-deployment --type=LoadBalancer --port=80 --target-port=80
```

### 4. Test
```bash
# Container Apps (immediate)
curl https://[container-app-url]

# AKS (after kubectl deployment)
curl http://[load-balancer-ip]
```

### 5. Cleanup
```bash
terraform destroy -auto-approve
```

## Task 2 Requirements Met

✅ **VNet with subnets**
- 2 public: 10.0.1.0/24, 10.0.2.0/24
- 2 private: 10.0.10.0/24, 10.0.11.0/24
- Container Apps: 10.0.20.0/23 (minimum /23 requirement)

✅ **Server-based (AKS)**
- Cluster in VNet
- Nodes in private subnet
- Load balancer in public subnet

✅ **Serverless (Container Apps)**
- Container Apps environment with VNet integration
- Dedicated /23 subnet
- External ingress enabled

✅ **Backend state**
- Azure Storage backend configured
- Remote state management enabled
