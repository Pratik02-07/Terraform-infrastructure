# Terraform Workspace & Git Branch Management

This project uses **Git branches** and **Terraform workspaces** together to maintain isolated infrastructure environments.
<img src="Terraform Branch-to-Workspace Workflow.png" alt="workflow diagram" />
The mapping is:

| Git Branch | Terraform Workspace | Environment |
|---|---|---|
| `main` | `default` | Production |
| `dev` | `dev` | Development |

> **Important:** Git branches and Terraform workspaces are independent. Switching a Git branch does **not** automatically switch the Terraform workspace.

---

## Architecture

```text
                    Git Repository
                         │
              ┌──────────┴──────────┐
              │                     │
          main branch           dev branch
          Production           Development
              │                     │
              ▼                     ▼
     Terraform workspace     Terraform workspace
          default                  dev
              │                     │
              ▼                     ▼
      AWS Production         AWS Development
        Resources              Resources
```

---

# 1. Check Current Git Branch

Before doing anything with Terraform, check which Git branch you are currently using.

```bash
git branch --show-current
```

Example:

```text
main
```

or:

```text
dev
```

You can also check your complete Git status:

```bash
git status
```

---

# 2. Check Current Terraform Workspace

Check the currently selected Terraform workspace:

```bash
terraform workspace show
```

Example:

```text
default
```

List all available workspaces:

```bash
terraform workspace list
```

Example:

```text
* default
  dev
```

The `*` indicates the currently selected workspace.

---

# 3. Git Branch → Terraform Workspace Mapping

Always maintain this mapping:

```text
main  ───────────────► default
                          │
                          ▼
                    Production AWS


dev   ───────────────► dev
                          │
                          ▼
                   Development AWS
```

Do not mix the environments.

### Production

```text
Git branch:       main
Terraform:        default
Environment:      Production
```

### Development

```text
Git branch:       dev
Terraform:        dev
Environment:      Development
```

---

# 4. Working on the `dev` Environment

Use the `dev` branch when developing or testing infrastructure changes.

## Step 1 — Switch to the dev branch

```bash
git checkout dev
```

Or with modern Git:

```bash
git switch dev
```

Pull the latest changes:

```bash
git pull origin dev
```

---

## Step 2 — Select the dev Terraform workspace

Check the current workspace:

```bash
terraform workspace show
```

Switch to `dev`:

```bash
terraform workspace select dev
```

Verify:

```bash
terraform workspace show
```

Expected:

```text
dev
```

If the workspace does not exist, create it:

```bash
terraform workspace new dev
```

Then verify:

```bash
terraform workspace show
```

Expected:

```text
dev
```

---

# 5. Initialize Terraform

After switching to the correct branch and workspace:

```bash
terraform init
```

If the backend configuration has changed:

```bash
terraform init -reconfigure
```

---

# 6. Review Development Changes

Create a Terraform plan:

```bash
terraform plan
```

For a variable file:

```bash
terraform plan -var-file="dev.tfvars"
```

Review the plan carefully before applying it.

---

# 7. Apply Development Infrastructure

Once the plan has been reviewed:

```bash
terraform apply
```

Or:

```bash
terraform apply -var-file="dev.tfvars"
```

Terraform will modify resources belonging to the `dev` workspace.

---

# 8. Switching Back to Production

When you need to work on production infrastructure, switch both the Git branch **and** Terraform workspace.

## Step 1 — Switch Git branch

```bash
git checkout main
```

Or:

```bash
git switch main
```

Pull the latest production configuration:

```bash
git pull origin main
```

---

## Step 2 — Switch Terraform workspace

```bash
terraform workspace select default
```

Verify:

```bash
terraform workspace show
```

Expected:

```text
default
```

---

# 9. Production Workflow

After switching to `main` + `default`:

```bash
terraform init
```

Check the plan:

```bash
terraform plan
```

If everything is correct:

```bash
terraform apply
```

For production, always review the plan before applying.

---

# 10. Complete Development Workflow

Use this workflow when developing infrastructure:

```bash
# 1. Switch to development branch
git switch dev

# 2. Get latest changes
git pull origin dev

# 3. Select development workspace
terraform workspace


ssh -i "terra-key-ec2" ubuntu@ <your-ec2-public-ip-address>





---

# 11. Current Terraform Configuration

The repository now contains four Terraform areas:

| Directory | Purpose |
|---|---|
| Root directory | EC2 infrastructure with a key pair, security group, Nginx user data, and two instance types |
| `remote-backend/` | S3 bucket and DynamoDB table used for remote Terraform state and state locking |
| `terraform-modules/` | Reusable application infrastructure for development, staging, and production |
| `terraform-eks/` | VPC and Amazon EKS cluster infrastructure |

## Remote Backend Bootstrap

Create the S3 bucket and DynamoDB lock table before initializing the root configuration:

```bash
cd remote-backend
terraform init
terraform plan
terraform apply
cd ..
terraform init -reconfigure
```

The root backend stores state in the `terraform-remote-state-bucket-0207` S3 bucket in `ap-south-1` and uses the `terraform-remote-state-table` DynamoDB table for locking.

## Root EC2 Infrastructure

The root configuration creates two EC2 instances with `for_each`: one `t3.micro` and one `t3.small`. It reads the public key from `terra-key-ec2.pub`, installs Nginx using `install_nginx.sh`, and allows inbound SSH on port `22`, HTTP on port `80`, and application traffic on port `8000`. After applying, view the public addresses with:

```bash
terraform output ec2_public_ip
terraform output ec2_public_dns
```

Connect to an instance with:

```bash
ssh -i "terra-key-ec2" ubuntu@<your-ec2-public-ip-address>
```

## Terraform Modules

The `terraform-modules` directory uses the `infra-app` module for three environments:

| Module | Instances | Type |
|---|---:|---|
| `dev-infra` | 1 | `t3.micro` |
| `stg-infra` | 1 | `t3.small` |
| `prd-infra` | 2 | `t3.medium` |

Run the module configuration independently:

```bash
cd terraform-modules
terraform init
terraform plan
terraform apply
cd ..
```

## EKS Infrastructure

The `terraform-eks` directory creates a VPC with public, private, and intra subnets, NAT and VPN gateways, and an Amazon EKS cluster. The cluster uses Kubernetes `1.31`, public API endpoint access, and a managed spot node group with two desired nodes and a maximum of three nodes.

Run it independently from the root configuration:

```bash
cd terraform-eks
terraform init
terraform plan
terraform apply
cd ..
```

Always review the plan and confirm the selected AWS account and region before applying any configuration.




