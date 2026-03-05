# Repository checklist

## Branch model
-  `dev`  integration
-  `stage`  pre-prod
-  `main`  production

```
git switch -c dev
git switch -c stage
git switch -c main
git push -u origin dev
git push -u origin stage
git push -u origin main
```

## Security & Moderation

Go to: Settings  Advanced Security

    Enable vulnerability alerts (Dependabot).
    Enable Dependabot security updates.
    Enable secret scanning (GitHub Advanced Security, if available).
    Enable push protection (blocks commits with exposed secrets).

## Branch Protection Rules

Go to: Settings  Branches  Branch protection rules  Add rule

Configure for main (or default branch):

    Require a pull request before merging
    Require approvals (at least 1-2)
    Dismiss stale pull request approvals
    Require review from Code Owners
    Require status checks to pass before merging (e.g., CI/CD checks)
    Require branches to be up to date before merging
    Require conversation resolution before merging
    Require linear history (optional but prevents merge commits)
    Do not allow bypassing the above settings (even for admins)


## Pull Request Validation
-  Conventional PR title (`feat|fix|chore`)
```
name: Convenitonal Pull Requests

on:
   pull_request:
     types:
      # Configure these types yourself!
      - opened
      - edited
      - reopened
      - synchronize
  
   workflow_dispatch:
  
jobs:
  validate:

    runs-on: ubuntu-latest
  
    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Validate PR Name
      uses: nivisi/conventional_pull_requests@1.0.0+2
      with:
         # GitHub Access Token
         # Required. Default is ${{ github.token }}
         github-token: ${{ github.token }}
  
         # Message that will be posted as a comment in the PR
         # In case the script finds an issue and will be capable of fixing it.
         # {AUTHOR} will be the author of the PR
         # {DIFF} is a suggested difference (old title vs new title)
         message-to-post: |
             Hey @{AUTHOR}  I'm the PR Bot!  I noticed that the title of this Pull Request didn't match the required schema, so I've made a quick fix:

             {DIFF}
```
-  Dockerfile lint
```
steps:
  - uses: actions/checkout@v3
  - uses: hadolint/hadolint-action@v3.1.0
    with:
      dockerfile: Dockerfile
```

## Versioning & Releases

-  Semantic versioning
```

- name: Application Version
  id: version
  uses: paulhatch/semantic-version@v5.4.0
  with:
    change_path: "src/service"
- name: Database Version
  id: db-version
  uses: paulhatch/semantic-version@v5.4.0
  with:
    major_pattern: "(MAJOR-DB)"
    minor_pattern: "(MINOR-DB)"
    change_path: "src/migrations"
    namespace: db

```
-  GitHub Releases auto-generated
```
name: Create GitHub Release

on:
  push:
    tags:
      - "v*"  # Trigger when a version tag is pushed (e.g., v1.0.0)

jobs:
  create-release:
    runs-on: ubuntu-latest

    permissions:
      contents: write

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Create GitHub Release
        uses: ncipollo/release-action@v1
        with:
          tag: $
          name: RuboCop $
          bodyFile: relnotes/$.md
          token: $
```
-  Rollback documented and tested
