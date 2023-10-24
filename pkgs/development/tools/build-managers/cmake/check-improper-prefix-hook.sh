cmakeImproperPrefixUsageCheckPhase() {
    while IFS= read -rd $'\0' file; do
        grepout=$(grep --line-number '}//nix/store' "$file" || true)
        if [ -n "$grepout" ]; then
            {
            echo "cmakeImproperPrefixUsageCheckPhase: Broken paths found in: $file"
            echo "The following lines have issues (specifically '//' in paths)."
            echo "$grepout"
            echo "It is very likely that paths are being joined improperly."
            echo 'ex: "${prefix}/@CMAKE_INSTALL_LIBDIR@" should be "@CMAKE_INSTALL_FULL_LIBDIR@"'
            echo "Please see https://github.com/NixOS/nixpkgs/issues/144170 for more details."
            exit 1
            } 1>&2
        fi
    done < <(find "${!outputDev}" -regextype posix-extended -iregex '.*\.(pc|cmake)' -print0)
}

postFixupHooks+=(cmakeImproperPrefixUsageCheckPhase)
