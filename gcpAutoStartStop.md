# Shell script to Start/Stop GCP Compute Instance using Compute Labels

I created this script to auto start and stop GCP compute instances grouped using labels as per set schedule using cronjob. Compute Instances were grouped using label name `environment`. Label `auto_start` and `auto_stop` will decide whether to perform start/stop action on the compute instance based on boolen value true/false.


## Prerequisite

* Set following labels to GCP compute instance
  * environment _(type: string)_
  * auto_stop _(type: bool),[true/false]_
  * auto_start _(type: bool),[true/false]_
* Create a GCP service account having "Compute Viewer" role. 
* Install gcloud SDK.
* Authenticate gcloud using service account file and create configuration profile with the name same as environment.
  - `gcloud auth activate-service-account --key-file {service_account_file}`
  - `gcloud init --project {gcp_project_id} --impersonate-service-account {service_account_file} --configuration {environment}`


## Usage

* Syntax:
  * `bash gcpAutoStartStop.sh {environment} [start/stop]`
* Example:
  * `bash gcpAutoStartStop.sh sandbox stop`
  * `bash gcpAutoStartStop.sh sandbox start`
* To Dry Run, set `print_only=true` as environment variable
  * `export print_only=true && bash gcpAutoStartStop.sh sandbox stop`
  * `export print_only=true && bash gcpAutoStartStop.sh sandbox start`


## Cronjob Schedule

In my case auto start action is needed every day at 10 AM except Staurdays and Sundays, and auto stop action is needed every day at 10 PM. Below is the crontab entries for reference:

```
0 22 * * 1-5 bash gcpAutoStartStop.sh sandbox start
0 10 * * * bash gcpAutoStartStop.sh sandbox stop
```