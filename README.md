# Helper scripts for Proxmox VE

## Usage

### Install additional soft into image
`./virt-update-image.sh <image>`

Example: `./virt-update-image.sh ./debian-12-genericcloud-amd64.qcow2`

### Create template from cloud-image
`./create-template.sh <image>`

Example: `./create-template.sh ./debian-12-genericcloud-amd64.qcow2`


## Misc

### How to get cloud image
`wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2`
