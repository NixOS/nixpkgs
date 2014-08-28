######################################################################
# hook handling utilities


# Run all hooks with the specified name in the order in which they
# were added, stopping if any fails (returns a non-zero exit
# code). The hooks for <hookName> are the shell function or variable
# <hookName>, and the values of the shell array ‘<hookName>Hooks’.
runHook() {
    local hookName="$1"
    shift
    local var="$hookName"
    if [[ "$hookName" =~ Hook$ ]]; then var+=s; else var+=Hooks; fi
    eval "local -a dummy=(\"\${$var[@]}\")"
    for hook in "_callImplicitHook 0 $hookName" "${dummy[@]}"; do
        if ! _eval "$hook" "$@"; then return 1; fi
    done
    return 0
}


# Run all hooks with the specified name, until one succeeds (returns a
# zero exit code). If none succeed, return a non-zero exit code.
runOneHook() {
    local hookName="$1"
    shift
    local var="$hookName"
    if [[ "$hookName" =~ Hook$ ]]; then var+=s; else var+=Hooks; fi
    eval "local -a dummy=(\"\${$var[@]}\")"
    for hook in "_callImplicitHook 1 $hookName" "${dummy[@]}"; do
        if _eval "$hook" "$@"; then
            return 0
        fi
    done
    return 1
}


# Run the named hook, either by calling the function with that name or
# by evaluating the variable with that name. This allows convenient
# setting of hooks both from Nix expressions (as attributes /
# environment variables) and from shell scripts (as functions). If you
# want to allow multiple hooks, use runHook instead.
_callImplicitHook() {
    local def="$1"
    local hookName="$2"
    case "$(type -t $hookName)" in
        (function|alias|builtin) $hookName;;
        (file) source $hookName;;
        (keyword) :;;
        (*) if [ -z "${!hookName}" ]; then return "$def"; else eval "${!hookName}"; fi;;
    esac
}


# A function wrapper around ‘eval’ that ensures that ‘return’ inside
# hooks exits the hook, not the caller.
_eval() {
    local code="$1"
    shift
    if [ "$(type -t $code)" = function ]; then
        eval "$code \"\$@\""
    else
        eval "$code"
    fi
}

