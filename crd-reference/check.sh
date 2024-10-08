#! /bin/bash

# Checks to make sure that the reference docs in the content/en/docs/reference directory
# are up-to-date with the Spin Operator CRDs

script_dir=$(dirname "$0")

cd $script_dir

echo "Checking for changes..."
cp ../content/en/docs/reference/spin-app-executor.md spin-app-executor.yaml.bak
cp ../content/en/docs/reference/spin-app.md spin-app.yaml.bak

./generate.sh > /dev/null 2>&1

has_changes=false
diff ../content/en/docs/reference/spin-app-executor.md spin-app-executor.yaml.bak > /dev/null
if [ $? -ne 0 ]; then
    has_changes=true
    echo "Changes found in spin-app-executor.md"
fi
diff ../content/en/docs/reference/spin-app.md spin-app.yaml.bak > /dev/null
if [ $? -ne 0 ]; then
    has_changes=true
    echo "Changes found in spin-app.md"
fi

mv spin-app-executor.yaml.bak ../content/en/docs/reference/spin-app-executor.md
mv spin-app.yaml.bak ../content/en/docs/reference/spin-app.md

if $has_changes; then
    echo "Changes found. Please run ./generate.sh"
    exit 1
fi

echo "No changes found"