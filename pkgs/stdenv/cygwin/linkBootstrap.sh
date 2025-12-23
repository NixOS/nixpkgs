#!/usr/bin/env bash

for path in $paths; do
  if [[ -e $src/$path.exe ]]; then
    path=$path.exe
  fi
  if ! [[ -e $src/$path ]]; then
    echo "Error: $path does not exist"
    exit 1
  fi
  mkdir -p $out/$(dirname $path)
  CYGWIN+=\ winsymlinks:nativestrict ln -s $src/$path $out/$path
done

addEnvHooks() {
  true
}

# HACK: copied from stdenv
# refactor cygwin-dll-link?
concatTo() {
    local -
    set -o noglob
    local -n targetref="$1"; shift
    local arg default name type
    for arg in "$@"; do
        IFS="=" read -r name default <<< "$arg"
        local -n nameref="$name"
        if [[ -z "${nameref[*]}" && -n "$default" ]]; then
            targetref+=( "$default" )
        elif type=$(declare -p "$name" 2> /dev/null); then
            case "${type#* }" in
                -A*)
                    echo "concatTo(): ERROR: trying to use concatTo on an associative array." >&2
                    return 1 ;;
                -a*)
                    targetref+=( "${nameref[@]}" ) ;;
                *)
                    if [[ "$name" = *"Array" ]]; then
                        nixErrorLog "concatTo(): $name is not declared as array, treating as a singleton. This will become an error in future"
                        # Reproduces https://github.com/NixOS/nixpkgs/pull/318614/files#diff-7c7ca80928136cfc73a02d5b28350bd900e331d6d304857053ffc9f7beaad576L359
                        targetref+=( ${nameref+"${nameref[@]}"} )
                    else
                        # shellcheck disable=SC2206
                        targetref+=( ${nameref-} )
                    fi
                    ;;
            esac
        fi
    done
}

source "$cygwinDllLink"

_linkDeps_inputPath=$src/bin
allowedImpureDLLs=(KERNEL32.dll ntdll.dll)
linkDLLs $out/bin

[[ ! -v postBuild ]] || eval "$postBuild"
