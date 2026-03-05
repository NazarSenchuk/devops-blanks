# AWS Account Setup checklist

- Enable Multi-Factor Authentication (MFA) for the Root User

- Enable AWS Cost Explorer

- Enable the Cost Optimization Hub

- Setup IAM users and Groups

```bash
# 1. Create Groups
aws iam create-group --group-name Admins
aws iam create-group --group-name Viewers

# 2. Attach Managed Policies
aws iam attach-group-policy --group-name Admins --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam attach-group-policy --group-name Viewers --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess

# 3. Create Users (examples)
aws iam create-user --user-name admin-user
aws iam create-user --user-name viewer-user

# 4. Add Users to Groups
aws iam add-user-to-group --user-name admin-user --group-name Admins
aws iam add-user-to-group --user-name viewer-user --group-name Viewers
```
- Set biling limits

- Setup Cloud Trail