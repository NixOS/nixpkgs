# Useful tool to check syntax of a config file. Upstart needs a dbus
# session, so this script wraps one up and makes the operation not
# require any prior state.
#
# See: http://mwhiteley.com/scripts/2012/12/11/dbus-init-checkconf.html
{stdenv, coreutils, upstart, writeScript, dbus}:

writeScript "upstart-check-config" ''
  #!${stdenv.shell}

  set -o errexit
  set -o nounset

  export PATH=${stdenv.lib.makeBinPath [dbus.out upstart coreutils]}:$PATH

  if [[ $# -ne 1 ]]
  then
    echo "Usage: $0 upstart-conf-file" >&2
    exit 1
  fi
  config=$1 && shift

  dbus_pid_file=$(mktemp)
  exec 4<> $dbus_pid_file

  dbus_add_file=$(mktemp)
  exec 6<> $dbus_add_file

  dbus-daemon --fork --print-pid 4 --print-address 6 --session

  function clean {
    dbus_pid=$(cat $dbus_pid_file)
    if [[ -n $dbus_pid ]]; then
      kill $dbus_pid
    fi
    rm -f $dbus_pid_file $dbus_add_file
  }
  trap "{ clean; }" EXIT

  export DBUS_SESSION_BUS_ADDRESS=$(cat $dbus_add_file)

  init-checkconf $config
''
