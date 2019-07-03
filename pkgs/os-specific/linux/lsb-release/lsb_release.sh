#! @shell@

set -o errexit
set -o nounset

show_help() {
  cat << EOF
Usage: lsb_release [options]

Options:
  -h, --help         show this help message and exit
  -v, --version      show LSB modules this system supports
  -i, --id           show distributor ID
  -d, --description  show description of this distribution
  -r, --release      show release number of this distribution
  -c, --codename     show code name of this distribution
  -a, --all          show all of the above information
  -s, --short        show requested information in short format
EOF
  exit 0
}

# Potential command-line options.
version=0
id=0
description=0
release=0
codename=0
all=0
short=0

getopt --test > /dev/null && rc=$? || rc=$?
if [[ $rc -ne 4 ]]; then
  # This shouldn't happen on any recent GNU system.
  echo "Warning: Enhanced getopt not supported, please open an issue." >&2
else
  # Define all short and long options.
  SHORT=hvidrcas
  LONG=help,version,id,description,release,codename,all,short

  # Parse all options.
  PARSED=`getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@"`
  if [[ $? -ne 0 ]]; then
    # getopt will print an error
    exit 1
  fi

  eval set -- "$PARSED"
fi


# Process each argument, and set the appropriate flag if we recognize it.
while [[ $# -ge 1 ]]; do
  case "$1" in
    -v|--version)
      version=1
      ;;
    -i|--id)
      id=1
      ;;
    -d|--description)
      description=1
      ;;
    -r|--release)
      release=1
      ;;
    -c|--codename)
      codename=1
      ;;
    -a|--all)
      all=1
      ;;
    -s|--short)
      short=1
      ;;
    -h|--help)
      show_help
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "lsb_release: unrecognized option '$1'"
      echo "Type 'lsb_release -h' for a list of available options."
      exit 1
      ;;
  esac
  shift
done

#  Read our variables.
if [[ -e /etc/os-release ]]; then
  . /etc/os-release
else
  echo "Error: /etc/os-release is not present, aborting." >&2
  exit 1
fi

# Default output
if [[ "$version" = "0" ]] && [[ "$id" = "0" ]] && \
   [[ "$description" = "0" ]] && [[ "$release" = "0" ]] && \
   [[ "$codename" = "0" ]] && [[ "$all" = "0" ]]; then
  echo "No LSB modules are available." >&2
  exit 0
fi

# Now output the data - The order of these was chosen to match
# what the original lsb_release used.

if [[ "$all" = "1" ]] || [[ "$version" = "1" ]]; then
  echo "No LSB modules are available." >&2
fi

if [[ "$all" = "1" ]] || [[ "$id" = "1" ]]; then
  if [[ "$short" = "0" ]]; then
    printf "Distributor ID:\t"
  fi
  echo $NAME
fi

if [[ "$all" = "1" ]] || [[ "$description" = "1" ]]; then
  if [[ "$short" = "0" ]]; then
    printf "Description:\t"
  fi
  echo $PRETTY_NAME
fi

if [[ "$all" = "1" ]] || [[ "$release" = "1" ]]; then
  if [[ "$short" = "0" ]]; then
    printf "Release:\t"
  fi
  echo $VERSION_ID
fi

if [[ "$all" = "1" ]] || [[ "$codename" = "1" ]]; then
  if [[ "$short" = "0" ]]; then
    printf "Codename:\t"
  fi
  echo $VERSION_CODENAME
fi
