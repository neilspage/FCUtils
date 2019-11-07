#!/bin/bash

#vars
declare -A stacks
stacks["targ_prod"]="targproduction.api.fluentretail.com"
stacks["targ_sandbox"]="targsandbox.api.fluentretail.com"
stacks["wool_prod"]="woolproduction.api.fluentretail.com"
stacks["wool_sandbox"]="woolsandbox.api.fluentretail.com"
stacks["multi_prod"]="multiproduction.api.fluentretail.com"
stacks["multi_sandbox"]="multisandbox.api.fluentretail.com"
stacks["dublin_prod"]="dublinproduction.api.fluentretail.com"
stacks["dublin_sandbox"]="dublinsandbox.api.fluentretail.com"
stacks["jduk_prod"]="jdukproduction.api.fluentretail.com"
stacks["jduk_sandbox"]="jduksandbox.api.fluentretail.com"

echo '[Listing current stack versions]'

for stack in "${!stacks[@]}"; do
     stackLink=${stacks[$stack]}
     stackId=`nslookup ${stackLink} | grep Name: | sed "s/Name:[[:blank:]]//g" | awk -F'-' '{ print $1 }' | head -n1`
     echo ${stack}: ${stackId}
done
