# jupyter-kubeflow-images

## Build Steps:
1. Install `gcloud`, and run `gcloud auth login`.

1. Select the type of image to build:

    **Jupyter - Lab - Full Anaconda:**
    ```bash
    export HUB_IMAGE_USER=continuumio
    export HUB_IMAGE_NAME=anaconda3
    export HUB_IMAGE_VERSION=2020.02
    export UI_TYPE=lab
    
    export INSTALL_SPARK=false
    export INSTALL_SPARK_VERSION=""
   
    # WARNING: update this value when you make changes between anaconda releases 
    export GCR_VERSION=1.0.0
    ```

    **Jupyter - Notebook - Full Anaconda:**
    ```bash
    export HUB_IMAGE_USER=continuumio
    export HUB_IMAGE_NAME=anaconda3
    export HUB_IMAGE_VERSION=2020.02
    export UI_TYPE=notebook
    
    export INSTALL_SPARK=false
    export INSTALL_SPARK_VERSION=""
   
    # WARNING: update this value when you make changes between anaconda releases 
    export GCR_VERSION=1.0.0
    ```
   
    **Jupyter - Lab - Miniconda:**
    ```bash
    export HUB_IMAGE_USER=continuumio
    export HUB_IMAGE_NAME=miniconda3
    export HUB_IMAGE_VERSION=4.8.2
    export UI_TYPE=lab
   
    export INSTALL_SPARK=false
    export INSTALL_SPARK_VERSION=""
   
    # WARNING: update this value when you make changes between anaconda releases 
    export GCR_VERSION=1.0.4
    ```
   
    **Jupyter - Notebook - Miniconda:**
    ```bash
    export HUB_IMAGE_USER=continuumio
    export HUB_IMAGE_NAME=miniconda3
    export HUB_IMAGE_VERSION=4.8.2
    export UI_TYPE=notebook      
   
    export INSTALL_SPARK=false
    export INSTALL_SPARK_VERSION=""
   
    # WARNING: update this value when you make changes between anaconda releases 
    export GCR_VERSION=1.0.0
    ```   
   
    **Jupyter - Lab - Miniconda with Spark 2.4.6:**
    ```bash
    export HUB_IMAGE_USER=continuumio
    export HUB_IMAGE_NAME=miniconda3
    export HUB_IMAGE_VERSION=4.8.2
    export UI_TYPE=lab
   
    export INSTALL_SPARK=true
    export INSTALL_SPARK_VERSION="2.4.6"
      
    # WARNING: update this value when you make changes between anaconda releases 
    export GCR_VERSION=1.0.0
    ```
    
    **Jupyter - Lab - Miniconda with Spark 3.0.0:**
    ```bash
    export HUB_IMAGE_USER=continuumio
    export HUB_IMAGE_NAME=miniconda3
    export HUB_IMAGE_VERSION=4.8.2
    export UI_TYPE=lab
   
    export INSTALL_SPARK=true
    export INSTALL_SPARK_VERSION="3.0.0"
      
    # WARNING: update this value when you make changes between anaconda releases 
    export GCR_VERSION=1.0.0
    ```
    
1. Run the build, and push:
    ```bash    
    export GCR_REPO=gcr.io/<<<MY_PROJECT>>>/kubeflow-images
   
    if [[ "$INSTALL_SPARK" = "true" ]] then
        GCR_IMAGE_TAG=${GCR_REPO}/jupyter-${UI_TYPE}-${HUB_IMAGE_NAME}-${HUB_IMAGE_VERSION}-spark-${INSTALL_SPARK_VERSION}:${GCR_VERSION}   
    else
        GCR_IMAGE_TAG=${GCR_REPO}/jupyter-${UI_TYPE}-${HUB_IMAGE_NAME}-${HUB_IMAGE_VERSION}:${GCR_VERSION}
    fi
   
    gcloud builds submit \
      --project <<<MY_PROJECT>>> \
      --config cloudbuild.yaml \
      --substitutions=$( printf '%s' \
          "_BASE_IMAGE_REPO=${HUB_IMAGE_USER}/${HUB_IMAGE_NAME}," \
          "_BASE_IMAGE_VERSION=${HUB_IMAGE_VERSION}," \
          "_INSTALL_SPARK=${INSTALL_SPARK}," \
          "_INSTALL_SPARK_VERSION=${INSTALL_SPARK_VERSION}," \
          "_NB_UI_TYPE=${UI_TYPE}," \
          "_GCR_IMAGE_TAG=${GCR_IMAGE_TAG}" \
        ) \
      --timeout=1800s
    ```