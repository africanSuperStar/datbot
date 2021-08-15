#!/bin/bash -eu

sudo apt-get update
sudo apt-get install google-cloud-sdk-cbt -y
sudo apt-get --only-upgrade install kubectl google-cloud-sdk=271.0.0-0 google-cloud-sdk-app-engine-grpc google-cloud-sdk-app-engine-go google-cloud-sdk-cloud-build-local google-cloud-sdk-datastore-emulator google-cloud-sdk-app-engine-python google-cloud-sdk-cbt=271.0.0-0 google-cloud-sdk-bigtable-emulator google-cloud-sdk-app-engine-python-extras google-cloud-sdk-datalab -y
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo pip3 install virtualenv
virtualenv -p python3 venv
source venv/bin/activate
sudo apt -y --allow-downgrades install google-cloud-sdk=271.0.0-0 google-cloud-sdk-cbt=271.0.0-0
cd ~
git clone https://github.com/africanSuperStar/datbot
gsutil cp README.md ${bucket_name}${bucket_folder}
echo "export PROJECT_ID=${project_id}" >> ~/.bashrc
echo "export REGION=${region}" >> ~/.bashrc
echo "export ZONE=${zone}" >> ~/.bashrc
echo "export BUCKET_NAME=gs://${bucket_name}" >> ~/.bashrc
echo "export BUCKET_FOLDER=${bucket_folder}" >> ~/.bashrc
echo "export BIGTABLE_INSTANCE_NAME=${bigtable_instance_name}" >> ~/.bashrc
echo "export BIGTABLE_TABLE_NAME=${bigtable_table_name}" >> ~/.bashrc
echo "export BIGTABLE_FAMILY_NAME=${bigtable_family_name}" >> ~/.bashrc
cbt -instance=$BIGTABLE_INSTANCE_NAME createtable $BIGTABLE_TABLE_NAME families=$BIGTABLE_FAMILY_NAME
cd frontend
pip install -r requirements.txt --user
python app.py $PROJECT_ID $BIGTABLE_INSTANCE_NAME $BIGTABLE_TABLE_NAME $BIGTABLE_FAMILY_NAME