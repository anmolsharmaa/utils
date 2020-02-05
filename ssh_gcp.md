# Shell script to SSH login to GCP Compute Instance using regexp pattern

I created this script to facilitate ssh login to any GCP instance based on any regexp pattern for target Compute Instance (Name,IP) so that I need not to remember any IP address or maintain any /etc/hosts entries. Regexp can be of any length, separated by space.


## Prerequisite

* Install and authenticate `gcloud` SDK. Afterwards, validate that `gcloud compute instances list` is giving out list of compute instances.
* Download and place (ssh_gcp)[ssh_gcp] at shell PATH with executable permission.
* In the file, set `SSH_PRIVATE_KEY_PATH` and `REMOTE_SSH_USER`. In my case, these 2 parameters are constant. So I avoid taking them as arguments or create aliases in shell. I only need to provide single input, which is a regexp for instance.


## Usage

* Syntax:
  * `ssh_gcp {regexp}`
* Example:
  * `ssh_gcp sandbox feature sale`
  * `ssh_gcp 10.103`
  * `ssh_gcp san fea cart 10.103`

