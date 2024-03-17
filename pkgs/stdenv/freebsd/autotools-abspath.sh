postPatchHooks+=(autotoolsAbspathHook)

autotoolsAbspathHook() {
    if [ -z "$dontAutopatchAutotools" ]; then
        find . \( -name 'configure' -o -name 'config.guess' \) -type f -exec \
            sed -e 's@/usr/bin/uname@uname@g' -i '{}' ';'
    fi
}
