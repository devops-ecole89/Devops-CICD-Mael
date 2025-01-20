#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
REPO_URL="git@github.com:devops-ecole89/Devops-Mael.git"
REPO_NAME="Devops-Mael"
REPO_BRANCH="dev"
REPO_BRANCH_MERGE="staging"

# Clone the git repository
git clone $REPO_URL
cd $REPO_NAME
git checkout $REPO_BRANCH

# Set PYTHONPATH to the current directory
export PYTHONPATH=$(pwd)

# Setup virtual environment and install dependencies
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Run the tests
pytest
TEST_RESULT=$?

# Check if the tests passed
if [ $TEST_RESULT -eq 0 ]; then
    echo "Tests passed, merging to staging"
    if git show-ref --verify --quiet refs/heads/$REPO_BRANCH_MERGE; then
        git checkout $REPO_BRANCH_MERGE
    else
        git checkout -b $REPO_BRANCH_MERGE
    fi
    git merge $REPO_BRANCH
    git push origin $REPO_BRANCH_MERGE

    cd ..
    rm -rf $REPO_NAME

    echo "Merge successful"
else
    echo "Tests failed, see pytest output for details"
    cd ..
    rm -rf $REPO_NAME
fi