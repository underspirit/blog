#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo -t red

# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ];then
    msg="$1"
    git commit -m "$msg"
else
    git commit
fi

# Push source and build repos.
git push origin master 
git subtree push --prefix=public origin gh-pages
