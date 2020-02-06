#!/bin/bash

# Usage:
# bash gcpAutoStartStop.sh <env> <start/stop>

# timeout for 2 minute is set for every gcloud command run

# function to perform start action
function _do_stop () {
	unset auto_stop environment
	eval $(echo ${1} | cut -d, -f3) 2>/dev/null || true

	if test ${environment} && test "${environment}" = "${st_env}"; then
		if test ${auto_stop} && ${auto_stop} 2>/dev/null; then
			${print_only:=false} || timeout 2m gcloud compute instances stop $(echo ${1} | cut -d, -f1) --zone $(echo ${1} | cut -d, -f2)
			${print_only:=false} && echo "gcloud compute instances stop $(echo ${1} | cut -d, -f1) --zone $(echo ${1} | cut -d, -f2)"
		else
			echo "skipping auto stop for $(echo ${1} | cut -d, -f1) because valueof(auto_stop) = \"${auto_stop}\"."
		fi
	else
		echo "skipping auto stop for $(echo ${1} | cut -d, -f1) because valueof(environment) = \"$environment\" is not equal to valueof(st_env) = \"${st_env}\"."
	fi
}

# function to perform stop action
function _do_start () {
	unset auto_start environment
	eval $(echo ${1} | cut -d, -f3) 2>/dev/null || true
        if test ${environment} && test "${environment}" = "${st_env}"; then
                if test ${auto_start} && ${auto_start} 2>/dev/null; then
                        ${print_only:=false} || timeout 2m gcloud compute instances start $(echo ${1} | cut -d, -f1) --zone $(echo ${1} | cut -d, -f2)
			${print_only:=false} && echo "gcloud compute instances start $(echo ${1} | cut -d, -f1) --zone $(echo ${1} | cut -d, -f2)"
                else
                        echo "skipping auto start for $(echo ${1} | cut -d, -f1) because valueof(auto_start) = \"${auto_start}\"."
                fi
        else
                echo "skipping auto start for $(echo ${1} | cut -d, -f1) because valueof(environment) = \"$environment\" is not equal to valueof(st_env) = \"${st_env}\"."
        fi
}

echo "- - - - - - - - $(date) - - - - - - - -"
timeout 2m gcloud config configurations activate ${1:?error - environment name is not set on \$1} || exit 1
export st_env=${1}
timeout 2m gcloud compute instances list --format="csv[no-heading](name,zone,labels)" > /tmp/${UID}_${1}
cat /tmp/${UID}_${1} | while read line; do _do_${2:?error - action name is not set on \$2} "${line}"; done
