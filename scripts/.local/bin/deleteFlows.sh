#!/bin/bash

apiName=$(basename $1 | grep -E "^[^.]+" -o)
sf force data soql query --query "SELECT Id FROM Flow WHERE Definition.developername = '$apiName' AND Status != 'Active'" --use-tooling-api --result-format csv > flowTodelete.csv
while read c; do
    if [[ "$c" != "Id" && "$c" != "Your query returned no results." ]]
        then
            sf data record delete --sobject Flow --record-id $c --use-tooling-api
    fi
done < flowTodelete.csv
rm flowTodelete.csv
