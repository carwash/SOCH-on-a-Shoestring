#!/usr/bin/env bash

# Search K-samsök using XML tools:
function query() {
  echo "Enter search term:"
	read query
	echo "Number of results (max 500)?"
	read number
	curl -s -g "http://kulturarvsdata.se/ksamsok/sru?operation=searchRetrieve&version=1.1&maximumRecords=$number&x-api=test&query=text=$query" \
		| xmlstarlet sel -N pres="http://kulturarvsdata.se/presentation#" -N srw="http://www.loc.gov/zing/srw/" --template --match "srw:searchRetrieveResponse/srw:records/srw:record/srw:recordData/pres:item" --sort A:T:- "pres:organization" -v "concat(pres:organization,'            ',pres:id,'            ',pres:type,'            ',pres:entityUri)" --nl \
		| grep -v '^$' \
		| sed -E 's!/(object|media|fmi)/!/\1/html/!g'
}

query
