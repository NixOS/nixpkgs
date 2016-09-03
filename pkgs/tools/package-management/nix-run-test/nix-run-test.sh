#! @shell@ -e

# Shows the usage of this command to the user

display_usage() {
    echo -e "Run a Nix test in a virtual machine.\nTests can be set to run interactively with the [-i|--interactive] flag."
    echo -e "\nUsage:\nnix-run-test [-i|--interactive] TEST\n"
    exit 0
}

# Parse valid argument options

PARAMS=`getopt -n $0 -o i,h -l interactive,help -- "$@"`

interactive="false"

if [ $? != 0 ]
then
    display_usage
    exit 1
fi

eval set -- "$PARAMS"

# Evaluate valid options

while [ "$1" != "--" ]
do
    case "$1" in
	-i|--interactive)
	    interactive="true"
	    ;;
	-h|--help)
	    display_usage
	    ;;
    esac
    
    shift
done

shift

# Validate the given options

if [ "$1" = "" ]
then
    display_usage
else
    testExpr=$(readlink -f $1)
fi

# Run the test

nix-build -E "with import <nixpkgs/lib/testing> {}; callTest $testExpr { interactive = $interactive; }"
