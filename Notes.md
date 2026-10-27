# Terraform Fundamentals: A Beginner’s Guide

## 1. What Is Terraform?

Terraform is an Infrastructure as Code (IaC) tool developed by HashiCorp. It allows engineers to create, modify, manage, and delete infrastructure using configuration files instead of performing every operation manually through a cloud portal.

Terraform supports multiple infrastructure platforms, including Microsoft Azure, Amazon Web Services (AWS), Google Cloud Platform (GCP), and other services through providers.

### Example

Without Terraform, an engineer might need to:

- Open the Azure Portal.
- Create a resource group.
- Create a virtual network.
- Configure a subnet.
- Create a virtual machine.
- Configure networking and security settings.

With Terraform, the engineer defines these resources in `.tf` files and executes Terraform commands to provision the infrastructure.

Example:

```hcl
resource "azurerm_resource_group" "example" {
  name     = "rg-terraform-demo"
  location = "Central India"
}
```

This configuration tells Terraform to manage an Azure resource group named `rg-terraform-demo`.

**Important:** Terraform does not create infrastructure merely because a configuration file exists. You must run the appropriate Terraform commands, and the necessary provider authentication and permissions must be configured.

## 2. Why Do We Use Terraform?

Terraform helps organizations manage infrastructure in a consistent, repeatable, and automated way.

### Main benefits

**1. Infrastructure as Code**

Infrastructure is defined in code files that can be stored in GitHub, GitLab, or Azure Repos.

**2. Automation**

Terraform can create and update infrastructure through automated pipelines using tools such as Jenkins, GitHub Actions, and Azure DevOps.

**3. Consistency**

The same configuration can be used to create similar environments, such as development, testing, and production.

**4. Reusability**

Terraform modules allow engineers to reuse configurations rather than repeatedly writing the same code.

**5. Change visibility**

The `terraform plan` command shows the proposed infrastructure changes before they are applied.

**6. Multi-cloud support**

Terraform can manage resources across Azure, AWS, GCP, and many other platforms.

**7. Version control**

Configuration files can be tracked in Git, allowing teams to review changes and collaborate.

**8. Reduced manual errors**

Automating repetitive infrastructure tasks reduces the chance of configuration mistakes, although the code and execution plan still need review.

## 3. How Terraform Works

Terraform works by comparing three important things:

- **Configuration:** What you want the infrastructure to look like, defined in `.tf` files.
- **State:** Terraform's record of the resources it manages.
- **Real infrastructure:** The actual resources in Azure, AWS, GCP, or another supported platform.

Terraform uses this information to calculate the changes required to make the real infrastructure match the desired configuration.

The plan can then be reviewed and applied.

## 4. The Four Main Terraform Stages

A practical four-command Terraform lifecycle is:

1. Initialize
2. Plan
3. Apply
4. Destroy

In everyday use, the first three commands are the main provisioning workflow. Destroy is used when managed infrastructure needs to be removed.

### Stage 1: Initialize — `terraform init`

Initialization prepares the working directory for Terraform operations.

Command:

```bash
terraform init
```

What happens during initialization?

- Terraform initializes the configured backend.
- Downloads the required provider plugins.
- Downloads required modules.
- Prepares the working directory.
- Creates or updates the dependency lock file when applicable.

Example: If you are deploying infrastructure to Azure, Terraform downloads the AzureRM provider required to communicate with Azure.

When should you run it?

- When starting a new Terraform project.
- After cloning a Terraform repository.
- When changing provider requirements, module sources, or backend configuration.

### Stage 2: Plan — `terraform plan`

Planning previews the changes Terraform proposes to make.

Command:

```bash
terraform plan
```

Terraform compares the configuration with its state and the current information available from the provider.

It may propose to:

- Create new resources.
- Update existing resources.
- Delete resources.
- Replace resources that cannot be updated in place.

Example output:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

This means Terraform proposes creating one resource, without changing or deleting any resources.

**Important:** Running `terraform plan` does not apply the proposed infrastructure changes.

Always review the plan before applying it, particularly in production environments.

### Stage 3: Apply — `terraform apply`

Apply executes the planned changes against the target infrastructure.

Command:

```bash
terraform apply
```

Terraform generates a plan and normally asks for confirmation before making changes.

Enter:

```text
yes
```

After approval, Terraform performs the required operations and updates its state to reflect the managed infrastructure.

Example output:

```text
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

For automated pipelines, teams can use a reviewed, saved plan:

```bash
terraform plan -out=tfplan
terraform apply tfplan
```

A saved plan can help ensure that the approved set of actions is the set being applied. However, teams should protect plan files because they may contain sensitive information.

### Stage 4: Destroy — `terraform destroy`

Destroy removes the infrastructure managed by the current Terraform configuration and workspace, according to the generated destruction plan.

Command:

```bash
terraform destroy
```

Terraform normally asks for confirmation before deleting resources.

Example output:

```text
Destroy complete! Resources: 1 destroyed.
```

Common use cases include:

- Removing temporary test environments.
- Cleaning up development infrastructure.
- Decommissioning resources that are no longer required.

**Warning:** Destroy can delete real infrastructure and cause service outages or data loss. Review the plan carefully before confirming.

### Terraform lifecycle summary

| Stage | Command | Purpose |
|---|---|---|
| 1. Initialize | `terraform init` | Prepare the working directory and dependencies |
| 2. Plan | `terraform plan` | Preview proposed changes |
| 3. Apply | `terraform apply` | Create, update, or remove resources according to the plan |
| 4. Destroy | `terraform destroy` | Remove managed infrastructure |

Note: Another widely used description of Terraform's core workflow is **Write → Plan → Apply**. Initialization prepares the working directory before normal operations, while destroy is a separate infrastructure lifecycle operation.

## 5. What Is the Terraform State File?

The Terraform state file is one of the most important components of Terraform.

By default, Terraform stores state locally in a file named:

```text
terraform.tfstate
```

Terraform uses this file to record information about the infrastructure it manages.

### What information does the state file contain?

The state file can include:

- Resource identifiers.
- Resource attributes.
- Relationships between managed resources.
- Metadata needed to manage resources.
- Sensitive values returned by providers or stored in resource attributes.

For example, after creating an Azure virtual machine, Terraform records the relationship between the resource declared in your configuration and the actual virtual machine in Azure.

### Why is the state file important?

**1. Resource tracking**

Terraform knows which real infrastructure objects correspond to the resources declared in the configuration.

**2. Change detection**

Terraform uses state together with configuration and provider information to calculate proposed changes.

**3. Resource management**

Terraform can update or delete resources it already manages.

**4. Dependency and metadata tracking**

State stores information Terraform needs to manage resources and their relationships.


### Local state versus remote state

**Local state**

Stored on the local machine in `terraform.tfstate`.

Advantages:
- Simple to set up.
- Suitable for learning and small experiments.

Disadvantages:
- Difficult to share safely across a team.
- Vulnerable to loss if the file is lost.
- Does not automatically provide shared team locking.

**Remote state**

Stored in a configured remote backend or managed Terraform service.

Advantages:
- Enables teams and automation pipelines to access shared state.
- Can support state locking and concurrency protection.
- Can provide centralized access control and recovery options, depending on the backend.

For production workloads, use a properly secured remote state solution with access controls, encryption, and locking where supported.

**Security note:** State files can contain secrets. Do not commit state files or secret-bearing plan files to a public Git repository.

## 6. Understanding Terraform Versions

There are two different version concepts that every Terraform engineer should understand.

### A. Terraform CLI version

The Terraform CLI is the Terraform executable installed on your computer or CI/CD agent.

Example:

```text
Terraform v1.16.5
on windows_amd64
```

This identifies the Terraform CLI version and the platform for which the executable was built.

You can check the installed version with:

```bash
terraform version
```

The CLI version determines which Terraform language features and behaviors are supported by that installation.

### B. Provider version

A provider is a plugin that allows Terraform to communicate with a particular platform or service.

Examples:

- `hashicorp/azurerm` — Azure
- `hashicorp/aws` — AWS
- `hashicorp/google` — Google Cloud

Provider versions are separate from Terraform CLI versions.

Example configuration:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

In this example:

- Terraform CLI version: The version of Terraform installed on the machine.
- Provider source: `hashicorp/azurerm`.
- Provider version: Exactly `5.0.0`, as specified by `= 5.0.0`.

The provider version is not the Terraform CLI version.

For example, a Terraform CLI installation reporting `1.16.5` and a configuration requiring AzureRM provider `5.0.0` are referring to two different components.

## 7. Why Do We Specify Versions?

Specifying version constraints helps maintain predictable behavior across machines and deployment pipelines.

For example, a developer may run Terraform on Windows while a CI/CD pipeline runs it on Linux. If both environments use compatible Terraform CLI versions and the same locked provider versions, the infrastructure workflow is easier to reproduce.

Version constraints help with:

- Compatibility.
- Repeatable deployments.
- Team collaboration.
- Controlled upgrades.
- Troubleshooting version-specific issues.
- Reducing unexpected changes caused by dependency updates.

### Specifying the Terraform CLI version

Use `required_version` inside the `terraform` block:

```hcl
terraform {
  required_version = ">= 1.10.0, < 2.0.0"
}
```

This is an example constraint, not a recommendation that every project use this exact range.

It means Terraform must be at least `1.10.0` and lower than `2.0.0`.

If the installed Terraform CLI does not satisfy the constraint, Terraform stops rather than proceeding with normal operations.

### Specifying the provider version

Use `required_providers`:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}
```

The constraint `~> 5.0` allows AzureRM provider versions from `5.0.0` up to, but not including, `6.0.0`.

This allows compatible updates within the 5.x series while excluding the 6.x series.

For comparison:

| Constraint | Meaning |
|---|---|
| `= 5.0.0` | Exactly version 5.0.0 |
| `>= 5.0.0` | Version 5.0.0 or later |
| `~> 5.0` | At least 5.0.0, but below 6.0.0 |
| `>= 5.0.0, < 6.0.0` | Explicitly allow versions in the 5.x range |

Remember that provider compatibility with your configuration and Terraform CLI must still be considered.

## 8. What Happens If We Do Not Specify a Version?

The result depends on which version you leave unspecified.

### Case 1: Provider version is not specified

Example:

```hcl
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
```

Terraform is not being told to use a specific AzureRM version or a bounded range.

When resolving dependencies, Terraform can select the newest provider version compatible with the other applicable requirements and available from the provider registry.

This can create problems if a new environment initializes the project later and selects a different provider version.

Possible risks include:

- Provider behavior changes.
- Deprecated arguments or attributes.
- Configuration validation errors.
- Differences between developer machines and CI/CD agents.
- Unexpected work required to upgrade the infrastructure code.

However, **not specifying a provider version does not mean Terraform downloads a new provider version every time you run `terraform apply`.**

After initialization, Terraform records selected provider versions in `.terraform.lock.hcl`. Normal subsequent initialization uses the lock file to reuse the selected versions when they satisfy the constraints. A fresh environment that has no lock file, or an initialization performed with upgrade behavior, can select different versions.

### Case 2: Terraform CLI version is not specified

Example:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}
```

Here, the provider is constrained, but the Terraform CLI version is not.

Terraform does not enforce a project-specific CLI version requirement. Different developers or pipeline agents may use different Terraform CLI releases.

Possible risks include:

- Different supported language features.
- Compatibility differences.
- Different command behavior or diagnostics.
- Inconsistent results when a configuration relies on version-specific behavior.

Terraform may still fail if a particular CLI version cannot interpret or execute the configuration or is incompatible with a required component.

### Case 3: Neither version is specified

This gives the project fewer explicit compatibility controls.

Terraform and provider selection may vary across environments, especially when initialization occurs without a shared dependency lock file.

For production projects, it is better to specify an appropriate Terraform CLI constraint, constrain provider versions, and commit the provider lock file.

## 9. What Is `.terraform.lock.hcl`?

This is a dependency lock file generated and maintained by Terraform.

Example filename:

```text
.terraform.lock.hcl
```

Its primary purpose is to record the selected provider versions and their checksums.

It helps ensure that subsequent initializations use the same provider versions when those versions satisfy the configured constraints.

### Is it the same as `terraform.tfstate`?

No.

| File | Purpose |
|---|---|
| `.terraform.lock.hcl` | Records selected provider versions and checksums |
| `terraform.tfstate` | Records Terraform's information about managed infrastructure |
| `.terraform/` directory | Stores working-directory data, including downloaded providers and modules |

For most projects, commit `.terraform.lock.hcl` to version control so that team members and CI/CD pipelines can reuse the same provider selections.

Do not commit `.terraform/` or local state files to a normal source repository unless you have a specific, carefully reviewed reason and appropriate security controls.

## 10. Example: Recommended Terraform Configuration

The following example combines the main version concepts for an Azure project.

```hcl
terraform {
  # Terraform CLI compatibility range
  required_version = ">= 1.10.0, < 2.0.0"

  # Azure provider dependency
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-terraform-demo"
  location = "Central India"
}
```

This example demonstrates:

1. A Terraform CLI version constraint.
2. A provider source.
3. A provider version constraint.
4. Azure provider configuration.
5. An Azure resource definition.

The version values are illustrative. Before using them in a real project, verify that the selected CLI and provider versions are supported and compatible with your configuration.

## 11. Commands to Remember

```bash
# Check Terraform CLI version
terraform version

# Initialize the working directory
terraform init

# Validate configuration syntax and consistency
terraform validate

# Format Terraform files
terraform fmt

# Preview changes
terraform plan

# Apply changes
terraform apply

# Show current state
terraform show

# List resources tracked in state
terraform state list

# Remove managed infrastructure
terraform destroy
```

Run these commands from the appropriate Terraform working directory. Commands that interact with providers may also require valid credentials, permissions, and initialized dependencies.

## 12. Best Practices for Real Projects

- Define an appropriate Terraform CLI version constraint.
- Constrain provider versions based on compatibility requirements.
- Commit `.terraform.lock.hcl` to version control.
- Use remote state with appropriate access controls for team projects.
- Enable state locking where supported.
- Never expose state files, credentials, or sensitive plan files publicly.
- Run `terraform fmt` and `terraform validate` before planning.
- Review `terraform plan` before applying changes.
- Use separate environments and carefully managed state for development, testing, and production.
- Upgrade Terraform and providers deliberately, review the resulting plan, and test changes before production deployment.
- Avoid manually editing the state file.
- Use CI/CD pipelines to automate repeatable, reviewed infrastructure deployments.

## 13. Interview Revision: Quick Questions and Answers

**Q1. What is Terraform?**

Terraform is an Infrastructure as Code tool used to provision and manage infrastructure through declarative configuration files.

**Q2. What are the four main Terraform lifecycle commands?**

`terraform init`, `terraform plan`, `terraform apply`, and `terraform destroy`.

**Q3. What is the purpose of `terraform init`?**

It prepares the working directory, initializes the backend, and installs required providers and modules.

**Q4. Does `terraform plan` create infrastructure?**

No. It previews proposed changes but does not apply them.

**Q5. What is a Terraform state file?**

It records information that Terraform uses to map declared resources to real infrastructure objects and manage them.

**Q6. What happens if the state file is lost?**

Terraform can lose track of managed resources and may propose unsafe or duplicate operations. The real resources may still exist.

**Q7. What is the difference between Terraform CLI and provider versions?**

The CLI version identifies the Terraform executable. The provider version identifies the plugin used to communicate with a platform such as Azure.

**Q8. What is the purpose of `required_version`?**

It defines which Terraform CLI versions are acceptable for the configuration.

**Q9. What is the purpose of `required_providers`?**

It identifies the required provider source and can specify the acceptable provider versions.

**Q10. What happens if a provider version is not constrained?**

Terraform can select a newer compatible provider version during dependency resolution. A lock file helps preserve the selected version across subsequent initializations.

**Q11. What is `.terraform.lock.hcl`?**

It records selected provider versions and checksums to support repeatable dependency installation.

**Q12. Can Terraform manage both Azure and AWS?**

Yes. Terraform can manage multiple platforms through their respective providers.

## 14. Official References

- Terraform documentation: https://developer.hashicorp.com/terraform/docs
- Core workflow: https://developer.hashicorp.com/terraform/intro/core-workflow
- Initialize Terraform: https://developer.hashicorp.com/terraform/cli/commands/init
- Terraform state: https://developer.hashicorp.com/terraform/language/state
- Version constraints: https://developer.hashicorp.com/terraform/language/expressions/version-constraints
- Terraform plan: https://developer.hashicorp.com/terraform/cli/commands/plan

---

**Final takeaway:** Terraform makes infrastructure repeatable and easier to automate. The four key lifecycle commands prepare the environment, preview changes, apply changes, and remove infrastructure. The state file tracks managed resources, while version constraints and the dependency lock file help keep deployments consistent across environments.