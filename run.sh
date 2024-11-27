#!/bin/bash

set -e
#Variables
REPO_URL="git@github.com:devops-ecole89/Devops-Mael.git"
REPO_NAME="Devops-Mael"
REPO_BRANCH="dev"
REPO_BRANCH_MERGE="staging"
# récuper le dépot git
git clone $REPO_URL
export PYTHONPATH=$(pwd)
cd $REPO_NAME
git checkout $REPO_BRANCH

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt


# Exécuter les tests
pytest
TEST_RESULT=$?

# Vérifier si les tests ont réussi
if [ $TEST_RESULT -eq 0 ]; then
    echo "Tests réussis, merge vers staging"
    if git show-ref --verify --quiet refs/heads/$REPO_BRANCH_MERGE; then
        git checkout $REPO_BRANCH_MERGE
    else
        git checkout -b $REPO_BRANCH_MERGE
    fi
    git merge $REPO_BRANCH_MERGE
    git push origin $REPO_BRANCH_MERGE

    cd ..
    rm -rf $REPO_NAME

    echo "Merge effectué avec succès"
else
    echo "Tests échoués, voir la sortie de pytest pour plus de détails"
    cd ..
    rm -rf $REPO_NAME
fi