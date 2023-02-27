#!/bin/bash
# set sh strict mode
set -o errexit
set -o nounset
IFS=$(printf '\n\t')

cd ${HOME}

echo "starting service as"
echo   User    : "$(id "$(whoami)")"
echo   Workdir : "$(pwd)"
echo "..."
echo

# ----------------------------------------------------------------

# Set-up inputs as required by tvb-recon
echo "Copying service inputs to /home/submitter/data/TVB1/raw/mri/"
mkdir -p /home/submitter/data/TVB1/raw/mri/
cp ${INPUT_1} /home/submitter/data/TVB1/raw/mri/t1_input.nii.gz
cp ${INPUT_2} /home/submitter/data/TVB1/raw/mri/dwi_raw.nii
cp ${INPUT_3} /home/submitter/data/TVB1/raw/mri/dwi.bvec
cp ${INPUT_4} /home/submitter/data/TVB1/raw/mri/dwi.bval

# If provided, use source code in the optional input_5, otherwise get it from Github
# Go to folder "pegasus" that contains the run script
if [ -d "${INPUT_FOLDER}/pegasus" ]
then
    echo "Using TVB source code from the inputs"
    cd "${INPUT_FOLDER}/pegasus"
else
    echo "No source code provided in the inputs. Using tvb-recon source code from Github"
    git clone https://github.com/the-virtual-brain/tvb-recon.git tvb_recon
    cd ${HOME}/tvb_recon/pegasus
fi

# If provided, use patient-specific config in the optional input_6.
# Overwrite the default one provided with the tvb-recon source code
if [ -f "${INPUT_FOLDER}/patient_flow.properties" ]
then
    echo "Using patient configuration file provided"
    cp "${INPUT_FOLDER}/patient_flow.properties" config/patient_flow.properties
else
    echo "No patient config file provided, using the default one."
fi

# Start the pipeline manager and run the pipeline. It will take about 4-6 hours
sudo condor_master
sleep 30
echo "Starting pipeline with run_sequentially..."
python run_sequentially.py "1"


# Retrieve outputs, zip it and move it to output folder
zip -j ${OUTPUT_FOLDER}/tvb.zip /home/submitter/data/TVB1/output/tvb
zip -j ${OUTPUT_FOLDER}/figs.zip /home/submitter/data/TVB1/output/figs
zip -j ${OUTPUT_FOLDER}/configs.zip /home/submitter/data/TVB1/configs
zip -j ${OUTPUT_FOLDER}/pegasus_logs.zip /home/submitter/pegasus/submit/scu/pegasus/TVB-PIPELINE/run0001