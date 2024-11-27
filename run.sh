#!/bin/bash

# Exécuter les tests
pytest
TEST_RESULT=$?

# Vérifier si les tests ont réussi
if [ $TEST_RESULT -eq 0 ]; then
    echo "Tests réussis, merge vers preprod"
    if git show-ref --verify --quiet refs/heads/preprod; then
        git checkout staging
    else
        git checkout -b staging
    fi
    #git merge dev
    #git push origin preprod
else
    echo "Tests échoués, voir la sortie de pytest pour plus de détails"

fi