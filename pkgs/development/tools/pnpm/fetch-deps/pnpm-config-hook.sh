# shellcheck shell=bash

pnpmConfigHook() {
    echo "Executing pnpmConfigHook"

    if [ -n "${pnpmRoot-}" ]; then
      pushd "$pnpmRoot"
    fi

    if [ -z "${pnpmDeps-}" ]; then
      echo "Error: 'pnpmDeps' must be set when using pnpmConfigHook."
      exit 1
    fi

    echo "Configuring pnpm store"

    export HOME=$(mktemp -d)
    export STORE_PATH=$(mktemp -d)

    cp -Tr "$pnpmDeps" "$STORE_PATH"
    chmod -R +w "$STORE_PATH"


    # If the packageManager field in package.json is set to a different pnpm version than what is in nixpkgs,
    # any pnpm command would fail in that directory, the following disables this
    pushd ..
    pnpm config set manage-package-manager-versions false
    popd

    pnpm config set store-dir "$STORE_PATH"

    if [[ -n "$pnpmWorkspace" ]]; then
        echo "'pnpmWorkspace' is deprecated, please migrate to 'pnpmWorkspaces'."
        exit 2
    fi

    echo "Installing dependencies"
    if [[ -n "$pnpmWorkspaces" ]]; then
        local IFS=" "
        for ws in $pnpmWorkspaces; do
            pnpmInstallFlags+=("--filter=$ws")
        done
    fi

    runHook prePnpmInstall

    if ! pnpm install \
        --offline \
        --ignore-scripts \
        "${pnpmInstallFlags[@]}" \
        --frozen-lockfile
    then
        echo
        echo "ERROR: pnpm failed to install dependencies"
        echo
        echo "If you see ERR_PNPM_NO_OFFLINE_TARBALL above this, follow these to fix the issue:"
        echo '1. Set pnpmDeps.hash to "" (empty string)'
        echo "2. Build the derivation and wait for it to fail with a hash mismatch"
        echo "3. Copy the 'got: sha256-' value back into the pnpmDeps.hash field"
        echo

        exit 1
    fi


    echo "Patching scripts"

    patchShebangs node_modules/{*,.*}

    if [ -n "${pnpmRoot-}" ]; then
      popd
    fi

    echo "Finished pnpmConfigHook"
}

postConfigureHooks+=(pnpmConfigHook)
