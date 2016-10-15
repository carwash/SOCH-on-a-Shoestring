#!/usr/bin/env bash

# Search K-samsök using XML tools:
function query() {
	echo "Enter search term:"
	read query
	echo "Number of results (max 500)?"
	read number
	curl -s -g "http://kulturarvsdata.se/ksamsok/api?method=search&version=1.1&hitsPerPage=$number&x-api=test&query=text=$query" \
		| xml sel -N pres="http://kulturarvsdata.se/presentation#" -N ns5="http://kulturarvsdata.se/ksamsok#" -N rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" --template --match "/result/records/record/rdf:RDF/rdf:Description/ns5:presentation/pres:item" --sort A:T:- "pres:organization" -v "concat(pres:organization,'            ',pres:id,'            ',pres:type,'            ',pres:entityUri)" --nl \
		| grep -v '^$' \
		| sed -E 's!/(object|media|fmi)/!/\1/html/!g'
}

query
