
# This function is meant to inspect the inputs to a derivation and source the shell completion.
# This is intended to be only used with nix-shell to provide a better user experience, and is not
# intended to be used within nixpkgs as shell completion is only useful in an interactive shell.
sourceInputCompletion() {
    local completionPath=

    case $(basename $SHELL) in
        bash)
            completionPath=share/bash-completion/completions/
            ;;
        fish)
            completionPath=share/fish/vendor_completions.d/
            ;;
        zsh)
            completionPath=share/zsh/site-functions/
            ;;
        *)
            echo "$(basename $SHELL) is not supported for shell completion. Skipping."
            exit 0
    esac

    declare -A inputsSourced
    for input in $nativeBuildInputs $buildInputs $propagatedNativeBuildInputs $propagatedBuildInputs; do
        local completionDir=$input/$completionPath
        if [ -d $completionDir ]; then
            for script in $(@findutils@/bin/find $completionDir -type f); do
                . $script
                # grab derivation pname. E.g. /nix/store/...-kubectl-1.19.4 -> kubectl
                inputsSourced[$(echo $input | sed -e 's/[^-]*-//' | sed -e 's/-.*$//')]=1
            done
        fi
    done

    echo "Completions added for: ${!inputsSourced[@]}"
}

if [ -z "$dontUseSourceInputCompletion" ]; then
  sourceInputCompletion
fi
