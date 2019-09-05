# Sentinel ATT&CK test lab

This terraform script provisions a win 10 machine and runs a post-deployment script to install sysmon.

# Set-up
1. Install/configure/authenticate Terraform following [these Microsoft docs](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure).
2. Create a _variables.tfvars_ file in the root directory, using the [_variables.tfvars.txt_](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/lab/variables.tfvars.txt) file as a template and making sure to complete all fields. 

    **The _variables.tfvars_ file is the heart of the terraform playbook** and it allows:
    - To securely specify authentication credentials (the file is ignored by git)
    - To define the lab name, active directory domain and provisioning location (eg. west us)
    - To define workstation and server accounts
    - To define workstation and server names, vm sizes and image configurations

3. Run the following command:

    ```terraform init```

4. Run the following command:

    ```terraform apply --var-file="variables.tfvars"```

As a next step you should [deploy Sentinel and onboard Sysmon data](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/guides/Sysmon-onboarding-quickstart.md). 
