# README

## `run.sh` Script

The `run.sh` script is designed to automate the process of cloning a Git repository, setting up a Python virtual environment, installing dependencies, running tests, and merging branches if the tests pass.

### Script Breakdown

1. **Set Script to Exit on Error**
   ```bash
   set -e
   ```
   This ensures that the script will exit immediately if any command exits with a non-zero status.

2. **Define Variables**
   ```bash
   REPO_URL="git@github.com:devops-ecole89/Devops-Mael.git"
   REPO_NAME="Devops-Mael"
   REPO_BRANCH="dev"
   REPO_BRANCH_MERGE="staging"
   ```
   These variables store the repository URL, the repository name, the branch to work on, and the branch to merge into if tests pass.

3. **Clone the Repository and Checkout the Branch**
   ```bash
   git clone $REPO_URL
   cd $REPO_NAME
   git checkout $REPO_BRANCH
   ```
   This clones the repository from the specified URL, navigates into the repository directory, and checks out the specified branch.

4. **Set `PYTHONPATH`**
   ```bash
   export PYTHONPATH=$(pwd)
   ```
   This sets the `PYTHONPATH` to the current directory to ensure that Python can find the modules.

5. **Setup Virtual Environment and Install Dependencies**
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```
   This creates a Python virtual environment, activates it, and installs the required dependencies from the `requirements.txt` file.

6. **Run Tests**
   ```bash
   pytest
   TEST_RESULT=$?
   ```
   This runs the tests using `pytest` and stores the result of the test run.

7. **Check Test Results and Merge if Successful**
   ```bash
   if [ $TEST_RESULT -eq 0 ]; then
       echo "Tests réussis, merge vers staging"
       if git show-ref --verify --quiet refs/heads/$REPO_BRANCH_MERGE; then
           git checkout $REPO_BRANCH_MERGE
       else
           git checkout -b $REPO_BRANCH_MERGE
       fi
       git merge $REPO_BRANCH
       git push origin $REPO_BRANCH_MERGE

       cd ..
       rm -rf $REPO_NAME

       echo "Merge effectué avec succès"
   else
       echo "Tests échoués, voir la sortie de pytest pour plus de détails"
       cd ..
       rm -rf $REPO_NAME
   fi
   ```
   If the tests pass (i.e., `TEST_RESULT` is 0), the script merges the current branch into the `staging` branch and pushes the changes to the remote repository. If the `staging` branch does not exist, it creates it. After merging, it cleans up by removing the cloned repository directory. If the tests fail, it outputs a failure message and also cleans up by removing the cloned repository directory.