#!/usr/bin/env bash
set -ex -o pipefail

# copy example notebooks
if [[ "$INSTALL_SPARK" == "true" ]] ; then
  export JAVA_HOME="/usr/lib/jvm/java-1.8.0-amazon-corretto"
  cp -r -n /opt/example_notebooks/spark_* "/home/${NB_USER}/"
  cp -r -n /opt/example_notebooks/gcs_* "/home/${NB_USER}"
fi

exec tini -- "$@"
