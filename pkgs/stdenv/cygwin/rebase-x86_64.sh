fixupOutputHooks+=(_cygwinFixAutoImageBase)

_cygwinFixAutoImageBase() {
    if [ "${dontRebase-}" == 1 ] || [ ! -d "$prefix" ]; then
        return
    fi
    find "$prefix" -name "*.dll" -type f | while read DLL; do
        if [ -f /etc/rebasenix.nextbase ]; then
            NEXTBASE="$(</etc/rebasenix.nextbase)"
        fi
        NEXTBASE=${NEXTBASE:-0x200000001}

        REBASE=(`/bin/rebase -i $DLL`)
        BASE=${REBASE[2]}
        SIZE=${REBASE[4]}
        SKIP=$(((($SIZE>>16)+1)<<16))

        echo "REBASE FIX: $DLL $BASE -> $NEXTBASE"
        /bin/rebase -b $NEXTBASE $DLL
        NEXTBASE="0x`printf %x $(($NEXTBASE+$SKIP))`"

        echo $NEXTBASE > /etc/rebasenix.nextbase
    done
}
