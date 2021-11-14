#! @shell@
# shellcheck shell=bash

set -o errexit
set -o nounset

show_help() {
  @coreutils@/bin/cat << EOF
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

@getopt@/bin/getopt --test > /dev/null && rc=$? || rc=$?
if [[ $rc -ne 4 ]]; then
  # This shouldn't happen.
  echo "Warning: Enhanced getopt not supported, please open an issue." >&2
else
  # Define all short and long options.
  SHORT=hvidrcas
  LONG=help,version,id,description,release,codename,all,short

  # Parse all options.
  PARSED=`@getopt@/bin/getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@"`

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
  OS_RELEASE_FOUND=1
else
  # This is e.g. relevant for the Nix build sandbox and compatible with the
  # original lsb_release binary:
  OS_RELEASE_FOUND=0
  NAME="n/a"
  PRETTY_NAME="(none)"
  VERSION_ID="n/a"
  VERSION_CODENAME="n/a"
fi

# Default output
if [[ "$version" = "0" ]] && [[ "$id" = "0" ]] && \
   [[ "$description" = "0" ]] && [[ "$release" = "0" ]] && \
   [[ "$codename" = "0" ]] && [[ "$all" = "0" ]]; then
  if [[ "$OS_RELEASE_FOUND" = "1" ]]; then
    echo "No LSB modules are available." >&2
  else
    if [[ "$short" = "0" ]]; then
      printf "LSB Version:\tn/a\n"
    else
      printf "n/a\n"
    fi
  fi
  exit 0
fi

# Now output the data - The order of these was chosen to match
# what the original lsb_release used.

SHORT_OUTPUT=""
append_short_output() {
  if [[ "$1" = "n/a" ]]; then
    SHORT_OUTPUT+=" $1"
  else
    SHORT_OUTPUT+=" \"$1\""
  fi
}

if [[ "$all" = "1" ]] || [[ "$version" = "1" ]]; then
  if [[ "$OS_RELEASE_FOUND" = "1" ]]; then
    if [[ "$short" = "0" ]]; then
      echo "No LSB modules are available." >&2
    else
      append_short_output "n/a"
    fi
  else
    if [[ "$short" = "0" ]]; then
      printf "LSB Version:\tn/a\n"
    else
      append_short_output "n/a"
    fi
  fi
fi

if [[ "$all" = "1" ]] || [[ "$id" = "1" ]]; then
  if [[ "$short" = "0" ]]; then
    printf "Distributor ID:\t$NAME\n"
  else
    append_short_output "$NAME"
  fi
fi

if [[ "$all" = "1" ]] || [[ "$description" = "1" ]]; then
  if [[ "$short" = "0" ]]; then
    printf "Description:\t$PRETTY_NAME\n"
  else
    append_short_output "$PRETTY_NAME"
  fi
fi

if [[ "$all" = "1" ]] || [[ "$release" = "1" ]]; then
  if [[ "$short" = "0" ]]; then
    printf "Release:\t$VERSION_ID\n"
  else
    append_short_output "$VERSION_ID"
  fi
fi

if [[ "$all" = "1" ]] || [[ "$codename" = "1" ]]; then
  if [[ "$short" = "0" ]]; then
    printf "Codename:\t$VERSION_CODENAME\n"
  else
    append_short_output "$VERSION_CODENAME"
  fi
fi

if [[ "$short" = "1" ]]; then
  # Output in one line without the first space:
  echo "${SHORT_OUTPUT:1}"
fi

# For compatibility with the original lsb_release:
if [[ "$OS_RELEASE_FOUND" = "0" ]]; then
  if [[ "$all" = "1" ]] || [[ "$id" = "1" ]] || \
     [[ "$description" = "1" ]] || [[ "$release" = "1" ]] || \
     [[ "$codename" = "1" ]]; then
    exit 3
  fi
fi
