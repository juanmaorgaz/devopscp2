# Create NIC
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface

resource "azurerm_network_interface" "masterNic" {
  name                = "master_nic1"  
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
    name                           = "master_ipconfiguration"
    subnet_id                      = azurerm_subnet.kubernetessubnet.id 
    private_ip_address_allocation  = "Static"
    private_ip_address             = "10.0.1.10"
    public_ip_address_id           = azurerm_public_ip.masterPublicIp.id
  }

    tags = {
        environment = "UNIR CP2"
        node        = "MASTER"
    }

}

# Create Public IP
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip

resource "azurerm_public_ip" "masterPublicIp" {
  name                = "master_Public_Ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = "UNIR CP2"
        node        = "MASTER"
    }

}

# Create Security Group
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group

resource "azurerm_network_security_group" "masterSecGroup" {
    name                = "master_sshtraffic"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "IN"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "10.0.1.0/24"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "SSH"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "30080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "UNIR CP2"
        node        = "MASTER"
    }
}

# Vinculate security group to network interface
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association

resource "azurerm_network_interface_security_group_association" "masterSecGroupAssociation" {
    network_interface_id      = azurerm_network_interface.masterNic.id
    network_security_group_id = azurerm_network_security_group.masterSecGroup.id

}

# Create Virtual Machine
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

resource "azurerm_linux_virtual_machine" "masterVM" {
    name                = "master-vm"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = "Standard_D2_v2" # 7 GB, 2 CPU
    admin_username      = var.ssh_user
    network_interface_ids = [ azurerm_network_interface.masterNic.id ]
    disable_password_authentication = true

    admin_ssh_key {
        username   = var.ssh_user
        public_key = file(var.public_key_path)
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    plan {
        name      = "centos-8-stream-free"
        product   = "centos-8-stream-free"
        publisher = "cognosys"
    }

    source_image_reference {
        publisher = "cognosys"
        offer     = "centos-8-stream-free"
        sku       = "centos-8-stream-free"
        version   = "1.2019.0810"
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.stAccount.primary_blob_endpoint
    }

    tags = {
        environment = "UNIR CP2"
        node        = "MASTER"
    }

}

output "public_ip_address_master" {
  description = "Public IP Master"
  value       = azurerm_public_ip.masterPublicIp.ip_address
}
output "network_interface_master" {
  description = "Private ip Master"
  value       = azurerm_network_interface.masterNic.private_ip_address
}