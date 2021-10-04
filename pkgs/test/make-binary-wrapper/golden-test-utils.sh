#!/usr/bin/env bash
# Split a generated C-file into the command used to generate it,
# and the outputted code itself.

# This is useful because it allows input and output to be inside the same file

# How it works:
# - The first line needs to start with '//' (and becomes the command).
# - Whitespace/padding between the comment and the generated code is ignored
# - To write a command using multiple lines, end each line with backslash (\)

# Count the number of lines before the output text starts
# commandLineCount FILE
commandLineCount() {
	local n state
	n=0
	state="init"
	while IFS="" read -r p || [ -n "$p" ]; do
		case $state in
			init)
				if [[ $p =~ ^//.*\\$ ]]; then state="comment"
				elif [[ $p =~ ^//.* ]]; then state="padding"
				else break
				fi
			;;
			comment) [[ ! $p =~ ^.*\\$ ]] && state="padding";;
			padding) [ -n "${p// }" ] && break;;
		esac
		n=$((n+1))
	done < "$1"
	printf '%s' "$n"
}

# getInputCommand FILE
getInputCommand() {
    n=$(commandLineCount "$1")
    head -n "$n" "$1" | awk '{ if (NR == 1) print substr($0, 3); else print $0 }'
}

# getOutputText FILE
getOutputText() {
    n=$(commandLineCount "$1")
    sed "1,${n}d" "$1"
}
