#! /bin/bash

set -e 

if [[ -z "$SPIN_OPERATOR_RELEASE" ]]; then
    echo "Must provide SPIN_OPERATOR_RELEASE in environment" 1>&2
    exit 1
fi

echo "Installing crdoc"
go install fybrik.io/crdoc@latest

echo "Downloading Spin Operator CRDs ($SPIN_OPERATOR_RELEASE) "
wget https://github.com/spinkube/spin-operator/releases/download/$SPIN_OPERATOR_RELEASE/spin-operator.crds.yaml

# Generate SpinAppExecutor Reference Docs
echo "Generating CRD reference docs for SpinAppExecutor"
crdoc -r spin-operator.crds.yaml \
    -o ../content/en/docs/spin-operator/reference/spin-app-executor.md \
    --toc ./spin-app-executor-toc.yaml \
    --template ./spin-operator.tmpl

echo "Generating CRD reference docs for SpinApp"
# Generate SpinApp Reference Docs
crdoc -r spin-operator.crds.yaml \
    -o ../content/en/docs/spin-operator/reference/spin-app.md \
    --toc ./spin-app-toc.yaml \
    --template ./spin-operator.tmpl

# Remove spin-operator.crds.yaml
rm spin-operator.crds.yaml

echo "Done."