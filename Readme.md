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




