#! /bin/sh

email=$1
shift

logfile=/tmp/logfile-$$ # !!! security
trap "rm $logfile" EXIT

echo $logfile

if ! "$@" > $logfile 2>&1; then
    BLOCKER=/tmp/inhibit-notify
    if ! test -f $BLOCKER; then
        HEAD=`head $logfile`
        TAIL=`tail $logfile`
        bzip2 < $logfile > $logfile.bz2
        mail -s "Nix build failed" -a $logfile.bz2 $email <<EOF
A Nix build failed.  See the attached log file for details.

No further messages will be sent until the file $BLOCKER is removed.

The first few lines of the log are:

$HEAD

The last few lines are:

$TAIL
EOF
        rm $logfile.bz2
        touch $BLOCKER
    fi
fi
