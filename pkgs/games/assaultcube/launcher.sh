#!@shell@
# original scripts are very awful

CUBE_DIR=@out@@gamedatadir@

case $(basename "$0") in
  assaultcube-server)
    CUBE_OPTIONS="-Cconfig/servercmdline.txt"
    BINARYPATH=@out@/bin/ac_server
    ;;
  assaultcube)
    CUBE_OPTIONS="--home=${HOME}/.assaultcube/v1.2next --init"
    BINARYPATH=@out@/bin/ac_client
    ;;
  *) echo "$0" is not supported.
     exit 1
esac

cd $CUBE_DIR
exec "${BINARYPATH}" ${CUBE_OPTIONS} "$@"
