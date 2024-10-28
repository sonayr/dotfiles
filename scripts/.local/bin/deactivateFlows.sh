#!/bin/bash

xmlstarlet edit -L -N w="http://soap.sforce.com/2006/04/metadata" -u "/w:Flow/w:status" -v 'Obsolete' $1
sf project deploy start -d $1
