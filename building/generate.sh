#!/bin/sh

# original based on neurodocker example 
# this version modified araound 2020-08-23
# for UoN use
#
# - go with different base image neurodebian:nd16.04
#   to make fslview work / compile
#
# - split out dependencies for pip install into a 
#   requirements.txt file (as per EH's project)
#
# @schluppeck



set -e

# grab the requirements from EH's file for this tool
pip_install_data=$(cat requirements.txt)

# and inform user that this is happening
echo "also pip installing: \n ${pip_install_data} \n"

# downgrade to 16.04 (xenial) to make fsl etc work 
# --base neurodebian:stretch-non-free \

# Generate Dockerfile
generate_docker() {
  docker run --rm repronim/neurodocker:master generate docker \
  --base neurodebian:nd16.04 \
  --pkg-manager apt \
  --install convert3d ants fsl fslview gcc g++ graphviz tree \
            git-annex-standalone vim emacs-nox nano less ncdu \
            tig git-annex-remote-rclone octave netbase \
  --add-to-entrypoint "source /etc/fsl/fsl.sh" \
  --user=neuro \
  --miniconda \
    conda_install="python=3.6 pytest jupyter jupyterlab jupyter_contrib_nbextensions
                   traits pandas matplotlib scikit-learn scikit-image seaborn nbformat nb_conda" \
    pip_install="${pip_install_data}" \
    create_env="neuro" \
    activate=true \
  --run-bash 'source activate neuro && jupyter nbextension enable exercise2/main && jupyter nbextension enable spellchecker/main' \
  --user=root \
  --run 'mkdir /data && chmod 777 /data && chmod a+s /data' \
  --run 'mkdir /output && chmod 777 /output && chmod a+s /output' \
  --user=neuro \
  --run-bash 'source activate neuro
    && cd /data
    && datalad install -r ///workshops/nih-2017/ds000114
    && cd ds000114
    && datalad update -r
    && datalad get -r sub-01/ses-test/anat sub-01/ses-test/func/*fingerfootlips*' \
  --run 'curl -L https://files.osf.io/v1/resources/fvuh8/providers/osfstorage/580705089ad5a101f17944a9 -o /data/ds000114/derivatives/fmriprep/mni_icbm152_nlin_asym_09c.tar.gz
    && tar xf /data/ds000114/derivatives/fmriprep/mni_icbm152_nlin_asym_09c.tar.gz -C /data/ds000114/derivatives/fmriprep/.
    && rm /data/ds000114/derivatives/fmriprep/mni_icbm152_nlin_asym_09c.tar.gz
    && find /data/ds000114/derivatives/fmriprep/mni_icbm152_nlin_asym_09c -type f -not -name ?mm_T1.nii.gz -not -name ?mm_brainmask.nii.gz -not -name ?mm_tpm*.nii.gz -delete' \
  --copy . "/home/neuro/nipype_tutorial" \
  --user=root \
  --run 'chown -R neuro /home/neuro/nipype_tutorial' \
  --run 'rm -rf /opt/conda/pkgs/*' \
  --user=neuro \
  --run 'mkdir -p ~/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > ~/.jupyter/jupyter_notebook_config.py' \
  --workdir /home/neuro/nipype_tutorial \
  --cmd jupyter-notebook
}

# actually generate the Docker file from which we can build the image
generate_docker > Dockerfile