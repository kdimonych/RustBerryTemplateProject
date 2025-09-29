#!/bin/bash
# This script creates a new GitHub repository with a README and a .gitignore file out of local one.
# It requires GitHub CLI (gh) to be installed and authenticated.
# Usage: ./init_github_repo.sh <repository_name> <description> <private|public>
set -e
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <repository_name> <description> <private|public>"
    exit 1
fi

REPO_NAME=$1
DESCRIPTION=$2
VISIBILITY=$3

if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) could not be found. Please install it first."
    echo "Visit https://cli.github.com/ for installation instructions."
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "You are not authenticated with GitHub CLI. Please run 'gh auth login' to authenticate."
    exit 1
fi

if gh repo view "$REPO_NAME" &> /dev/null; then
    echo "Repository '$REPO_NAME' already exists on GitHub."
    exit 1
fi

if [ "$VISIBILITY" != "private" ] && [ "$VISIBILITY" != "public" ]; then
    echo "Visibility must be either 'private' or 'public'"
    exit 1
fi

# Check if current directory is an initialized git repository, if not - initialize one
if [ -d ".git" ]; then
    echo "Git repository already initialized."
else
    git init
fi

if [ ! -f "README.md" ]; then
    echo "# $REPO_NAME" > README.md
    echo "$DESCRIPTION" >> README.md
    echo "Created README.md"
else
    echo "README.md already exists."
fi

if [ ! -f ".gitignore" ]; then
    echo "Creating a standard .gitignore file for a general project."
    cat <<EOL > .gitignore
# Compiled source #
###################################
*.com
*.class
*.dll
*.exe
*.obj
*.so
*.pyc
*.pyo
*.pyd
*.jar
*.war
*.ear

# Rust specific
/target/
**/*.rs.bk
.#*
.gdb_history
Cargo.lock

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE files
.vscode/*
!.vscode/*.md
!.vscode/*.svd
!.vscode/launch.json
!.vscode/tasks.json
!.vscode/extensions.json
!.vscode/settings.json

# Environment files
.env
.env.local
.env.production
.env.test

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOL
    echo "Created .gitignore file."
else
    echo ".gitignore already exists."
fi

# if there is no commit yet, create an initial commit
if ! git rev-parse HEAD >/dev/null 2>&1; then
    echo "No commits found. Creating an initial commit."
    git add .
    git commit -m "Initial commit"
else
    echo "Git repository already has commits."
fi

# Create a new GitHub repository
gh repo create "$REPO_NAME" --source=. --remote=origin --"$VISIBILITY" --description "$DESCRIPTION" --confirm --push
