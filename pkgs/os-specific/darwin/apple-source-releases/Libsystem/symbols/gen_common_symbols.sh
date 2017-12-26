#!/bin/bash

set -e
set -x

productVersions=( 10.11.6 10.12.6 10.13.2 )
lists=( system_c_symbols_i386 system_c_symbols_x86_64 system_kernel_symbols_i386 system_kernel_symbols_x86_64 )
first="${productVersions[0]}"
unset -v 'productVersions[0]'
for l in "${lists[@]}"; do
	cp "$first"/"$l" current
	for v in "${productVersions[@]}"; do
		comm -12 current "$v"/"$l" > current_new
		mv current_new current
	done
	mv current "$l"
done
