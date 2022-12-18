# shellcheck shell=bash
set -e

exitError() {
    echo "$1" >&2
    exit 1
}

eval "[[ "foo" =~ "foo" ]]" 2>/dev/null || exitError "error: get-env.sh uses pattern matching but the derivation builder does not support this"
eval "declare -a arr=()" 2>/dev/null || exitError "error: get-env.sh uses arrays but the derivation builder does not support this"

# shellcheck disable=SC1090  # Dynamic sourcing is intentional
if [ -e "$NIX_ATTRS_SH_FILE" ]; then source "$NIX_ATTRS_SH_FILE"; fi

export IN_NIX_SHELL=impure
export dontAddDisableDepTrack=1

if [[ -n $stdenv ]]; then
    # shellcheck disable=SC1091  # setup file is in nix store
    source "$stdenv"/setup
fi

# Better to use compgen, but stdenv bash doesn't have it.
__vars="$(declare -p)"
__functions="$(declare -F)"

declare -a __saved_vars=("PATH" "XDG_DATA_DIRS")

__shell="$1"

__dumpEnv() {
    printf "unset shellHook\n\n"

    for var in "${__saved_vars[@]}"; do
        printf '%s=${%s:-}\n' "$var" "$var"
        printf 'nix_saved_%s="$%s"\n' "$var" "$var"
    done
    printf '\n'

    while read -r __line; do
        if ! [[ $__line =~ ^declare\ -f\ (.*) ]]; then continue; fi
        __fun_name="${BASH_REMATCH[1]}"
        __fun_body="$(type "$__fun_name")"
        if [[ $__fun_body =~ \{(.*)\} ]]; then
            __fun_body="${BASH_REMATCH[1]}"
            printf "%s() {%s}\n\n" "$__fun_name" "$__fun_body"
        else
            printf "Cannot parse definition of function '%s'.\n" "$__fun_name" >&2
            return 1
        fi
    done < <(printf "%s\n" "$__functions")

    while read -r __line; do
        if ! [[ $__line =~ ^declare\ (-[^ ])\ ([^=]*) ]]; then continue; fi
        local type="${BASH_REMATCH[1]}"
        local __var_name="${BASH_REMATCH[2]}"

        if [[ $__var_name =~ ^BASH_ || \
              $__var_name =~ ^COMP_ || \
              $__var_name = _ || \
              $__var_name = DIRSTACK || \
              $__var_name = EUID || \
              $__var_name = FUNCNAME || \
              $__var_name = HISTCMD || \
              $__var_name = HOSTNAME || \
              $__var_name = GROUPS || \
              $__var_name = PIPESTATUS || \
              $__var_name = PWD || \
              $__var_name = RANDOM || \
              $__var_name = SHLVL || \
              $__var_name = SECONDS || \
              $__var_name = EPOCHREALTIME || \
              $__var_name = EPOCHSECONDS || \
              $__var_name = LINENO \
            ]]; then continue; fi

        if [[ $type == -x ]] || [[ $type == -- ]] || [[ $type == -a ]] || [[ $type == -A ]]; then
            printf '%s\n' "$__line"
        fi
    done < <(printf "%s\n" "$__vars")
    printf '\n'

    for var in "${__saved_vars[@]}"; do
        printf '%s="$%s${nix_saved_%s:+:$nix_saved_%s}"\n' "$var" "$var" "$var" "$var"
    done
    printf '\n'

    printf '%s\n'   'if [[ -z "${NIX_BUILD_TOP:-}" ]]; then'
    printf '%s\n'   '    export NIX_BUILD_TOP="$(mktemp -d -t devshell.XXXXXX)"'
    printf '%s\n\n' 'fi'

    for var in "TMP" "TMPDIR" "TEMP" "TEMPDIR"; do
        printf 'export %s="$NIX_BUILD_TOP"\n' "$var"
    done
    printf '\n'

    printf '%s\n\n' 'eval "${shellHook:-}"'
}

__dumpRc() {
    printf '#!%s --rcfile\n\n' "$__shell"

    printf 'if [[ -z "${NIX_DEVSHELL_PHASE:-}" && -z "${NIX_DEVSHELL_COMMAND:-}" ]]; then\n'
    printf '    [ -n "$PS1" ] && [ -e ~/.bashrc ] && source ~/.bashrc;\n'
    printf '    shopt -u expand_aliases\n'
    printf 'fi\n\n'

    __dumpEnv

    printf '%s\n'   'if [[ ! -z "${NIX_DEVSHELL_VERBOSE:-}" ]]; then'
    printf '%s\n'   '    set -x'
    printf '%s\n\n' 'fi'

    printf '%s\n'   'if [[ ! -z "${NIX_DEVSHELL_PHASE:-}" ]]; then'
    printf '%s\n'   '    cd "${NIX_DEVSHELL_PHASE_SRCPATH:-.}"'
    printf '%s\n'   '    runHook ${NIX_DEVSHELL_PHASE}Phase'
    printf '%s\n'   '    exit "$?"'
    printf '%s\n'   'elif [[ ! -z "${NIX_DEVSHELL_COMMAND:-}" ]]; then'
    printf '%s\n'   '    eval "$NIX_DEVSHELL_COMMAND"'
    printf '%s\n'   '    exit "$?"'
    printf '%s\n'   'else'
    printf '%s\n'   '    shopt -s expand_aliases'
    printf '%s\n'   '    if [[ ! -z "${NIX_DEVSHELL_PROMPT:-}" ]]; then'
    printf '%s\n'   '        [ -n "$PS1" ] && PS1="$NIX_DEVSHELL_PROMPT";'
    printf '%s\n'   '    fi'
    printf '%s\n'   '    if [[ ! -z "${NIX_DEVSHELL_PROMPT_PREFIX:-}" ]]; then'
    printf '%s\n'   '        [ -n "$PS1" ] && PS1="$NIX_DEVSHELL_PROMPT_PREFIX$PS1";'
    printf '%s\n'   '    fi'
    printf '%s\n'   '    if [[ ! -z "${NIX_DEVSHELL_PROMPT_SUFFIX:-}" ]]; then'
    printf '%s\n'   '        [ -n "$PS1" ] && PS1+="${NIX_DEVSHELL_PROMPT_SUFFIX}";'
    printf '%s\n'   '    fi'
    printf '%s\n\n' 'fi'

    printf 'SHELL="%s"\n' "$__shell"
    printf '%s\n' 'if [[ $(dirname "$SHELL") != "." ]]; then'
    printf '%s\n' '    PATH="$(dirname "$SHELL")${PATH:+:$PATH}"'
    printf '%s\n' 'fi'
}

__dumpEnvJson() {
    printf '{\n'

    printf '  "bashFunctions": {\n'
    local __first=1
    while read -r __line; do
        if ! [[ $__line =~ ^declare\ -f\ (.*) ]]; then continue; fi
        __fun_name="${BASH_REMATCH[1]}"
        __fun_body="$(type "$__fun_name")"
        if [[ $__fun_body =~ \{(.*)\} ]]; then
            if [[ -z $__first ]]; then printf ',\n'; else __first=; fi
            __fun_body="${BASH_REMATCH[1]}"
            printf "    "
            __escapeString "$__fun_name"
            printf ':'
            __escapeString "$__fun_body"
        else
            printf "Cannot parse definition of function '%s'.\n" "$__fun_name" >&2
            return 1
        fi
    done < <(printf "%s\n" "$__functions")
    printf '\n  },\n'

    printf '  "variables": {\n'
    local __first=1
    while read -r __line; do
        if ! [[ $__line =~ ^declare\ (-[^ ])\ ([^=]*) ]]; then continue; fi
        local type="${BASH_REMATCH[1]}"
        local __var_name="${BASH_REMATCH[2]}"

        if [[ $__var_name =~ ^BASH_ || \
              $__var_name =~ ^COMP_ || \
              $__var_name = _ || \
              $__var_name = DIRSTACK || \
              $__var_name = EUID || \
              $__var_name = FUNCNAME || \
              $__var_name = HISTCMD || \
              $__var_name = HOSTNAME || \
              $__var_name = GROUPS || \
              $__var_name = PIPESTATUS || \
              $__var_name = PWD || \
              $__var_name = RANDOM || \
              $__var_name = SHLVL || \
              $__var_name = SECONDS || \
              $__var_name = EPOCHREALTIME || \
              $__var_name = EPOCHSECONDS || \
              $__var_name = LINENO \
            ]]; then continue; fi

        if [[ -z $__first ]]; then printf ',\n'; else __first=; fi

        printf "    "
        __escapeString "$__var_name"
        printf ': {'

        # FIXME: handle -i, -r, -n.
        if [[ $type == -x ]]; then
            printf '"type": "exported", "value": '
            __escapeString "${!__var_name}"
        elif [[ $type == -- ]]; then
            printf '"type": "var", "value": '
            __escapeString "${!__var_name}"
        elif [[ $type == -a ]]; then
            printf '"type": "array", "value": ['
            local __first2=1
            # shellcheck disable=SC1087  # Complex array manipulation, syntax is correct
            __var_name="$__var_name[@]"
            # shellcheck disable=SC1087  # Complex array manipulation, syntax is correct
            for __i in "${!__var_name}"; do
                if [[ -z $__first2 ]]; then printf ', '; else __first2=; fi
                __escapeString "$__i"
                printf ' '
            done
            printf ']'
        elif [[ $type == -A ]]; then
            printf '"type": "associative", "value": {\n'
            local __first2=1
            declare -n __var_name2="$__var_name"
            for __i in "${!__var_name2[@]}"; do
                if [[ -z $__first2 ]]; then printf ',\n'; else __first2=; fi
                printf "      "
                __escapeString "$__i"
                printf ": "
                __escapeString "${__var_name2[$__i]}"
            done
            printf '\n    }'
        else
            printf '"type": "unknown"'
        fi

        printf "}"
    done < <(printf "%s\n" "$__vars")
    printf '\n  }'

    if [ -e "$NIX_ATTRS_SH_FILE" ]; then
        printf ',\n  "structuredAttrs": {\n    '
        __escapeString ".attrs.sh"
        printf ': '
        __escapeString "$(<"$NIX_ATTRS_SH_FILE")"
        printf ',\n    '
        __escapeString ".attrs.json"
        printf ': '
        __escapeString "$(<"$NIX_ATTRS_JSON_FILE")"
        printf '\n  }'
    fi

    printf '\n}'
}

__escapeString() {
    local __s="$1"
    __s="${__s//\\/\\\\}"
    __s="${__s//\"/\\\"}"
    __s="${__s//$'\n'/\\n}"
    __s="${__s//$'\r'/\\r}"
    __s="${__s//$'\t'/\\t}"
    printf '"%s"' "$__s"
}

__rewriteOutputs() {
    __in=$(</dev/stdin)

    if [ -e "$NIX_ATTRS_SH_FILE" ]; then
        for __output in ${!outputs[@]}; do
            __in="${__in//${outputs[$__output]}/\$PWD/outputs/$__output}"
        done
    elif [[ ! -z "$outputs" ]]; then
        for __outname in $outputs; do
            __in="${__in//${!__outname}/\$PWD/outputs/$__outname}"
        done
    else
        __in="${__in//$out/\$PWD/outputs/out}"
    fi

    printf "%s" "${__in}"
}

__dumpToOutput() {
    local __output="$1"
    if [[ -z ${__done-} ]]; then
        mkdir "$__output"
        __dumpEnvJson > "${__output}/env.json"
        __dumpEnv | __rewriteOutputs > "${__output}/env"
        mkdir "${__output}/bin"
        __dumpRc  | __rewriteOutputs > "${__output}/bin/setup"
        chmod +x "${__output}/bin/setup"
        __done=1
    else
        echo -n >> "$__output"
    fi
}

# In case of `__structuredAttrs = true;` the list of outputs is an associative
# array with a format like `outname => /nix/store/hash-drvname-outname`.
# Otherwise it is a space-separated list of output variable names.
if [ -e "$NIX_ATTRS_SH_FILE" ]; then
    # shellcheck disable=SC2154  # outputs is set by sourced file
    for __output in "${outputs[@]}"; do
        __dumpToOutput "$__output"
    done
elif [[ ! -z "$outputs" ]]; then
    for __outname in $outputs; do
        __dumpToOutput "${!__outname}"
    done
else
    __dumpToOutput "$out"
fi
