#!@shell@

OLDPATH="$PATH"
OLDTZ="$TZ"
OLD_http_proxy="$http_proxy"
OLD_ftp_proxy="$http_proxy"
source @myenvpath@

PATH="$PATH:$OLDPATH"
export PS1="\n@name@:[\u@\h:\w]\$ "
export NIX_MYENV_NAME="@name@"
export buildInputs
export NIX_STRIP_DEBUG=0
export TZ="$OLDTZ"
export http_proxy="$OLD_http_proxy"
export ftp_proxy="$OLD_ftp_proxy"

if test $# -gt 0; then
    exec "$@"
else
    exec @shell@
fi

