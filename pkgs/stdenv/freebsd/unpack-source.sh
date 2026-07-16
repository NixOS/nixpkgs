unpackCmdHooks+=(_FreeBSDUnpackSource)

_FreeBSDUnpackSource() {
    local fn="$1"
    local destination

    if [ -d "$fn" ]; then

        destination="$(stripHash "$fn")"

        if [ -e "$destination" ]; then
            echo "Cannot copy $fn to $destination: destination already exists!"
            echo "Did you specify two \"srcs\" with the same \"name\"?"
            return 1
        fi

        # We can't preserve hardlinks because they may have been
        # introduced by store optimization, which might break things
        # in the build.
        bsdcp -a -- "$fn" "$destination"
        chmod -R +w "$destination"

    else

        case "$fn" in
            *.tar.xz | *.tar.lzma | *.txz)
                # Don't rely on tar knowing about .xz.
                xz -d < "$fn" | tar xf - --warning=no-timestamp
                ;;
            *.tar | *.tar.* | *.tgz | *.tbz2 | *.tbz)
                # GNU tar can automatically select the decompression method
                # (info "(tar) gzip").
                tar xf "$fn" --warning=no-timestamp
                ;;
            *)
                return 1
                ;;
        esac

    fi
}
