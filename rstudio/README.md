# rstudio-kubeflow-image

## Build Steps:
1. Install `gcloud`, and run `gcloud auth login`.

1. Select the type of image to build:

    **RStudio - Base:**
    ```bash
    export HUB_IMAGE_USER=rocker
    export HUB_IMAGE_NAME=rstudio
    export HUB_IMAGE_VERSION=3.6.3
   
    # WARNING: update this value when you make changes between R releases 
    export GCR_VERSION=1.0.0
    ```

    **RStudio - Tidyverse:**
    ```bash
    export HUB_IMAGE_USER=rocker
    export HUB_IMAGE_NAME=tidyverse
    export HUB_IMAGE_VERSION=3.6.3
   
    # WARNING: update this value when you make changes between R releases 
    export GCR_VERSION=1.0.0
    ```


1. Run the build, and push:
    ```bash    
    export GCR_REPO=gcr.io/<<<MY_PROJECT_NAME>>>/kubeflow-images
   
    gcloud builds submit \
      --project <<<MY_PROJECT_NAME>>> \
      --config cloudbuild.yaml \
      --substitutions=$( printf '%s' \
          "_BASE_IMAGE_REPO=${HUB_IMAGE_USER}/${HUB_IMAGE_NAME}," \
          "_BASE_IMAGE_VERSION=${HUB_IMAGE_VERSION}," \
          "_GCR_IMAGE_TAG=${GCR_REPO}/rstudio-${HUB_IMAGE_NAME}-${HUB_IMAGE_VERSION}:${GCR_VERSION}" \
        ) \
      --timeout=1800s
    ```