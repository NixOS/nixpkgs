#! @runtimeShell@
# shellcheck shell=bash

if [ -x "@runtimeShell@" ]; then export SHELL="@runtimeShell@"; fi;

set -e
set -o pipefail
shopt -s inherit_errexit

export PATH=@path@:$PATH

showSyntax() {
    exec man nixos-rebuild
    exit 1
}


# Parse the command line.
origArgs=("$@")
copyClosureFlags=()
extraBuildFlags=()
lockFlags=()
flakeFlags=()
action=
buildNix=1
fast=
rollback=
upgrade=
upgrade_all=
profile=/nix/var/nix/profiles/system
buildHost=localhost
targetHost=
remoteSudo=
# comma separated list of vars to preserve when using sudo
preservedSudoVars=NIXOS_INSTALL_BOOTLOADER

while [ "$#" -gt 0 ]; do
    i="$1"; shift 1
    case "$i" in
      --help)
        showSyntax
        ;;
      switch|boot|test|build|edit|dry-build|dry-run|dry-activate|build-vm|build-vm-with-bootloader)
        if [ "$i" = dry-run ]; then i=dry-build; fi
        action="$i"
        ;;
      --install-grub)
        echo "$0: --install-grub deprecated, use --install-bootloader instead" >&2
        export NIXOS_INSTALL_BOOTLOADER=1
        ;;
      --install-bootloader)
        export NIXOS_INSTALL_BOOTLOADER=1
        ;;
      --no-build-nix)
        buildNix=
        ;;
      --rollback)
        rollback=1
        ;;
      --upgrade)
        upgrade=1
        ;;
      --upgrade-all)
        upgrade=1
        upgrade_all=1
        ;;
      -s|--use-substitutes)
        copyClosureFlags+=("$i")
        ;;
      --max-jobs|-j|--cores|-I|--builders)
        j="$1"; shift 1
        extraBuildFlags+=("$i" "$j")
        ;;
      --show-trace|--keep-failed|-K|--keep-going|-k|--verbose|-v|-vv|-vvv|-vvvv|-vvvvv|--fallback|--repair|--no-build-output|-Q|-j*|-L|--refresh|--no-net|--offline|--impure)
        extraBuildFlags+=("$i")
        ;;
      --option)
        j="$1"; shift 1
        k="$1"; shift 1
        extraBuildFlags+=("$i" "$j" "$k")
        ;;
      --fast)
        buildNix=
        fast=1
        ;;
      --profile-name|-p)
        if [ -z "$1" ]; then
            echo "$0: ‘--profile-name’ requires an argument"
            exit 1
        fi
        if [ "$1" != system ]; then
            profile="/nix/var/nix/profiles/system-profiles/$1"
            mkdir -p -m 0755 "$(dirname "$profile")"
        fi
        shift 1
        ;;
      --build-host|h)
        buildHost="$1"
        shift 1
        ;;
      --target-host|t)
        targetHost="$1"
        shift 1
        ;;
      --use-remote-sudo)
        remoteSudo=1
        ;;
      --flake)
        flake="$1"
        flakeFlags=(--extra-experimental-features 'nix-command flakes')
        shift 1
        ;;
      --recreate-lock-file|--no-update-lock-file|--no-write-lock-file|--no-registries|--commit-lock-file)
        lockFlags+=("$i")
        ;;
      --update-input)
        j="$1"; shift 1
        lockFlags+=("$i" "$j")
        ;;
      --override-input)
        j="$1"; shift 1
        k="$1"; shift 1
        lockFlags+=("$i" "$j" "$k")
        ;;
      *)
        echo "$0: unknown option \`$i'"
        exit 1
        ;;
    esac
done

if [[ -n "$SUDO_USER" || -n $remoteSudo ]]; then
    maybeSudo=(sudo --preserve-env="$preservedSudoVars" --)
fi

if [ -z "$buildHost" -a -n "$targetHost" ]; then
    buildHost="$targetHost"
fi
if [ "$targetHost" = localhost ]; then
    targetHost=
fi
if [ "$buildHost" = localhost ]; then
    buildHost=
fi

buildHostCmd() {
    if [ -z "$buildHost" ]; then
        "$@"
    elif [ -n "$remoteNix" ]; then
        ssh $SSHOPTS "$buildHost" "${maybeSudo[@]}" env PATH="$remoteNix":'$PATH' "$@"
    else
        ssh $SSHOPTS "$buildHost" "${maybeSudo[@]}" "$@"
    fi
}

targetHostCmd() {
    if [ -z "$targetHost" ]; then
        "${maybeSudo[@]}" "$@"
    else
        ssh $SSHOPTS "$targetHost" "${maybeSudo[@]}" "$@"
    fi
}

copyToTarget() {
    if ! [ "$targetHost" = "$buildHost" ]; then
        if [ -z "$targetHost" ]; then
            NIX_SSHOPTS=$SSHOPTS nix-copy-closure "${copyClosureFlags[@]}" --from "$buildHost" "$1"
        elif [ -z "$buildHost" ]; then
            NIX_SSHOPTS=$SSHOPTS nix-copy-closure "${copyClosureFlags[@]}" --to "$targetHost" "$1"
        else
            buildHostCmd nix-copy-closure "${copyClosureFlags[@]}" --to "$targetHost" "$1"
        fi
    fi
}

nixBuild() {
    if [ -z "$buildHost" ]; then
        nix-build "$@"
    else
        local instArgs=()
        local buildArgs=()
        local drv=

        while [ "$#" -gt 0 ]; do
            local i="$1"; shift 1
            case "$i" in
              -o)
                local out="$1"; shift 1
                buildArgs+=("--add-root" "$out" "--indirect")
                ;;
              -A)
                local j="$1"; shift 1
                instArgs+=("$i" "$j")
                ;;
              -I) # We don't want this in buildArgs
                shift 1
                ;;
              --no-out-link) # We don't want this in buildArgs
                ;;
              "<"*) # nix paths
                instArgs+=("$i")
                ;;
              *)
                buildArgs+=("$i")
                ;;
            esac
        done

        drv="$(nix-instantiate "${instArgs[@]}" "${extraBuildFlags[@]}")"
        if [ -a "$drv" ]; then
            NIX_SSHOPTS=$SSHOPTS nix-copy-closure --to "$buildHost" "$drv"
            buildHostCmd nix-store -r "$drv" "${buildArgs[@]}"
        else
            echo "nix-instantiate failed"
            exit 1
        fi
  fi
}

nixFlakeBuild() {
    if [[ -z "$buildHost" && -z "$targetHost" ]] &&
       ! [ "$action" = switch -o "$action" = boot ]
    then
        nix "${flakeFlags[@]}" build "$@"
        readlink -f ./result
    elif [ -z "$buildHost" ]; then
        nix "${flakeFlags[@]}" build "$@" --out-link "${tmpDir}/result"
        readlink -f "${tmpDir}/result"
    else
        local attr="$1"
        shift 1
        local evalArgs=()
        local buildArgs=()
        local drv=

        while [ "$#" -gt 0 ]; do
            local i="$1"; shift 1
            case "$i" in
              --recreate-lock-file|--no-update-lock-file|--no-write-lock-file|--no-registries|--commit-lock-file)
                evalArgs+=("$i")
                ;;
              --update-input)
                local j="$1"; shift 1
                evalArgs+=("$i" "$j")
                ;;
              --override-input)
                local j="$1"; shift 1
                local k="$1"; shift 1
                evalArgs+=("$i" "$j" "$k")
                ;;
              *)
                buildArgs+=("$i")
                ;;
            esac
        done

        drv="$(nix "${flakeFlags[@]}" eval --raw "${attr}.drvPath" "${evalArgs[@]}" "${extraBuildFlags[@]}")"
        if [ -a "$drv" ]; then
            NIX_SSHOPTS=$SSHOPTS nix "${flakeFlags[@]}" copy --derivation --to "ssh://$buildHost" "$drv"
            buildHostCmd nix-store -r "$drv" "${buildArgs[@]}"
        else
            echo "nix eval failed"
            exit 1
        fi
    fi
}


if [ -z "$action" ]; then showSyntax; fi

# Only run shell scripts from the Nixpkgs tree if the action is
# "switch", "boot", or "test". With other actions (such as "build"),
# the user may reasonably expect that no code from the Nixpkgs tree is
# executed, so it's safe to run nixos-rebuild against a potentially
# untrusted tree.
canRun=
if [ "$action" = switch -o "$action" = boot -o "$action" = test ]; then
    canRun=1
fi


# If ‘--upgrade’ or `--upgrade-all` is given,
# run ‘nix-channel --update nixos’.
if [[ -n $upgrade && -z $_NIXOS_REBUILD_REEXEC && -z $flake ]]; then
    # If --upgrade-all is passed, or there are other channels that
    # contain a file called ".update-on-nixos-rebuild", update them as
    # well. Also upgrade the nixos channel.

    for channelpath in /nix/var/nix/profiles/per-user/root/channels/*; do
        channel_name=$(basename "$channelpath")

        if [[ "$channel_name" == "nixos" ]]; then
            nix-channel --update "$channel_name"
        elif [ -e "$channelpath/.update-on-nixos-rebuild" ]; then
            nix-channel --update "$channel_name"
        elif [[ -n $upgrade_all ]] ; then
            nix-channel --update "$channel_name"
        fi
    done
fi

# Make sure that we use the Nix package we depend on, not something
# else from the PATH for nix-{env,instantiate,build}.  This is
# important, because NixOS defaults the architecture of the rebuilt
# system to the architecture of the nix-* binaries used.  So if on an
# amd64 system the user has an i686 Nix package in her PATH, then we
# would silently downgrade the whole system to be i686 NixOS on the
# next reboot.
if [ -z "$_NIXOS_REBUILD_REEXEC" ]; then
    export PATH=@nix@/bin:$PATH
fi

# Use /etc/nixos/flake.nix if it exists. It can be a symlink to the
# actual flake.
if [[ -z $flake && -e /etc/nixos/flake.nix ]]; then
    flake="$(dirname "$(readlink -f /etc/nixos/flake.nix)")"
fi

# Re-execute nixos-rebuild from the Nixpkgs tree.
# FIXME: get nixos-rebuild from $flake.
if [[ -z $_NIXOS_REBUILD_REEXEC && -n $canRun && -z $fast && -z $flake ]]; then
    if p=$(nix-build --no-out-link --expr 'with import <nixpkgs/nixos> {}; config.system.build.nixos-rebuild' "${extraBuildFlags[@]}"); then
        export _NIXOS_REBUILD_REEXEC=1
        exec "$p/bin/nixos-rebuild" "${origArgs[@]}"
        exit 1
    fi
fi

# For convenience, use the hostname as the default configuration to
# build from the flake.
if [[ -n $flake ]]; then
    if [[ $flake =~ ^(.*)\#([^\#\"]*)$ ]]; then
       flake="${BASH_REMATCH[1]}"
       flakeAttr="${BASH_REMATCH[2]}"
    fi
    if [[ -z $flakeAttr ]]; then
        read -r hostname < /proc/sys/kernel/hostname
        if [[ -z $hostname ]]; then
            hostname=default
        fi
        flakeAttr="nixosConfigurations.\"$hostname\""
    else
        flakeAttr="nixosConfigurations.\"$flakeAttr\""
    fi
fi

# Resolve the flake.
if [[ -n $flake ]]; then
    flake=$(nix "${flakeFlags[@]}" flake metadata --json "${extraBuildFlags[@]}" "${lockFlags[@]}" -- "$flake" | jq -r .url)
fi

# Find configuration.nix and open editor instead of building.
if [ "$action" = edit ]; then
    if [[ -z $flake ]]; then
        NIXOS_CONFIG=${NIXOS_CONFIG:-$(nix-instantiate --find-file nixos-config)}
        if [[ -d $NIXOS_CONFIG ]]; then
            NIXOS_CONFIG=$NIXOS_CONFIG/default.nix
        fi
        exec ${EDITOR:-nano} "$NIXOS_CONFIG"
    else
        exec nix "${flakeFlags[@]}" edit "${lockFlags[@]}" -- "$flake#$flakeAttr"
    fi
    exit 1
fi


tmpDir=$(mktemp -t -d nixos-rebuild.XXXXXX)
SSHOPTS="$NIX_SSHOPTS -o ControlMaster=auto -o ControlPath=$tmpDir/ssh-%n -o ControlPersist=60"

cleanup() {
    for ctrl in "$tmpDir"/ssh-*; do
        ssh -o ControlPath="$ctrl" -O exit dummyhost 2>/dev/null || true
    done
    rm -rf "$tmpDir"
}
trap cleanup EXIT


# First build Nix, since NixOS may require a newer version than the
# current one.
if [ -n "$rollback" -o "$action" = dry-build ]; then
    buildNix=
fi

nixSystem() {
    machine="$(uname -m)"
    if [[ "$machine" =~ i.86 ]]; then
        machine=i686
    fi
    echo $machine-linux
}

prebuiltNix() {
    machine="$1"
    if [ "$machine" = x86_64 ]; then
        echo @nix_x86_64_linux@
    elif [[ "$machine" =~ i.86 ]]; then
        echo @nix_i686_linux@
    elif [[ "$machine" = aarch64 ]]; then
        echo @nix_aarch64_linux@
    else
        echo "$0: unsupported platform"
        exit 1
    fi
}

if [[ -n $buildNix && -z $flake ]]; then
    echo "building Nix..." >&2
    nixDrv=
    if ! nixDrv="$(nix-instantiate '<nixpkgs/nixos>' --add-root "$tmpDir/nix.drv" --indirect -A config.nix.package.out "${extraBuildFlags[@]}")"; then
        if ! nixDrv="$(nix-instantiate '<nixpkgs>' --add-root "$tmpDir/nix.drv" --indirect -A nix "${extraBuildFlags[@]}")"; then
            if ! nixStorePath="$(nix-instantiate --eval '<nixpkgs/nixos/modules/installer/tools/nix-fallback-paths.nix>' -A "$(nixSystem)" | sed -e 's/^"//' -e 's/"$//')"; then
                nixStorePath="$(prebuiltNix "$(uname -m)")"
            fi
            if ! nix-store -r $nixStorePath --add-root $tmpDir/nix --indirect \
                --option extra-binary-caches https://cache.nixos.org/; then
                echo "warning: don't know how to get latest Nix" >&2
            fi
            # Older version of nix-store -r don't support --add-root.
            [ -e "$tmpDir/nix" ] || ln -sf "$nixStorePath" "$tmpDir/nix"
            if [ -n "$buildHost" ]; then
                remoteNixStorePath="$(prebuiltNix "$(buildHostCmd uname -m)")"
                remoteNix="$remoteNixStorePath/bin"
                if ! buildHostCmd nix-store -r "$remoteNixStorePath" \
                  --option extra-binary-caches https://cache.nixos.org/ >/dev/null; then
                    remoteNix=
                    echo "warning: don't know how to get latest Nix" >&2
                fi
            fi
        fi
    fi
    if [ -a "$nixDrv" ]; then
        nix-store -r "$nixDrv"'!'"out" --add-root "$tmpDir/nix" --indirect >/dev/null
        if [ -n "$buildHost" ]; then
            nix-copy-closure "${copyClosureFlags[@]}" --to "$buildHost" "$nixDrv"
            # The nix build produces multiple outputs, we add them all to the remote path
            for p in $(buildHostCmd nix-store -r "$(readlink "$nixDrv")" "${buildArgs[@]}"); do
                remoteNix="$remoteNix${remoteNix:+:}$p/bin"
            done
        fi
    fi
    PATH="$tmpDir/nix/bin:$PATH"
fi


# Update the version suffix if we're building from Git (so that
# nixos-version shows something useful).
if [[ -n $canRun && -z $flake ]]; then
    if nixpkgs=$(nix-instantiate --find-file nixpkgs "${extraBuildFlags[@]}"); then
        suffix=$($SHELL "$nixpkgs/nixos/modules/installer/tools/get-version-suffix" "${extraBuildFlags[@]}" || true)
        if [ -n "$suffix" ]; then
            echo -n "$suffix" > "$nixpkgs/.version-suffix" || true
        fi
    fi
fi


if [ "$action" = dry-build ]; then
    extraBuildFlags+=(--dry-run)
fi


# Either upgrade the configuration in the system profile (for "switch"
# or "boot"), or just build it and create a symlink "result" in the
# current directory (for "build" and "test").
if [ -z "$rollback" ]; then
    echo "building the system configuration..." >&2
    if [ "$action" = switch -o "$action" = boot ]; then
        if [[ -z $flake ]]; then
            pathToConfig="$(nixBuild '<nixpkgs/nixos>' --no-out-link -A system "${extraBuildFlags[@]}")"
        else
            pathToConfig="$(nixFlakeBuild "$flake#$flakeAttr.config.system.build.toplevel" "${extraBuildFlags[@]}" "${lockFlags[@]}")"
        fi
        copyToTarget "$pathToConfig"
        targetHostCmd nix-env -p "$profile" --set "$pathToConfig"
    elif [ "$action" = test -o "$action" = build -o "$action" = dry-build -o "$action" = dry-activate ]; then
        if [[ -z $flake ]]; then
            pathToConfig="$(nixBuild '<nixpkgs/nixos>' -A system -k "${extraBuildFlags[@]}")"
        else
            pathToConfig="$(nixFlakeBuild "$flake#$flakeAttr.config.system.build.toplevel" "${extraBuildFlags[@]}" "${lockFlags[@]}")"
        fi
    elif [ "$action" = build-vm ]; then
        if [[ -z $flake ]]; then
            pathToConfig="$(nixBuild '<nixpkgs/nixos>' -A vm -k "${extraBuildFlags[@]}")"
        else
            pathToConfig="$(nixFlakeBuild "$flake#$flakeAttr.config.system.build.vm" "${extraBuildFlags[@]}" "${lockFlags[@]}")"
        fi
    elif [ "$action" = build-vm-with-bootloader ]; then
        if [[ -z $flake ]]; then
            pathToConfig="$(nixBuild '<nixpkgs/nixos>' -A vmWithBootLoader -k "${extraBuildFlags[@]}")"
        else
            pathToConfig="$(nixFlakeBuild "$flake#$flakeAttr.config.system.build.vmWithBootLoader" "${extraBuildFlags[@]}" "${lockFlags[@]}")"
        fi
    else
        showSyntax
    fi
    # Copy build to target host if we haven't already done it
    if ! [ "$action" = switch -o "$action" = boot ]; then
        copyToTarget "$pathToConfig"
    fi
else # [ -n "$rollback" ]
    if [ "$action" = switch -o "$action" = boot ]; then
        targetHostCmd nix-env --rollback -p "$profile"
        pathToConfig="$profile"
    elif [ "$action" = test -o "$action" = build ]; then
        systemNumber=$(
            targetHostCmd nix-env -p "$profile" --list-generations |
            sed -n '/current/ {g; p;}; s/ *\([0-9]*\).*/\1/; h'
        )
        pathToConfig="$profile"-${systemNumber}-link
        if [ -z "$targetHost" ]; then
            ln -sT "$pathToConfig" ./result
        fi
    else
        showSyntax
    fi
fi


# If we're not just building, then make the new configuration the boot
# default and/or activate it now.
if [ "$action" = switch -o "$action" = boot -o "$action" = test -o "$action" = dry-activate ]; then
    if ! targetHostCmd "$pathToConfig/bin/switch-to-configuration" "$action"; then
        echo "warning: error(s) occurred while switching to the new configuration" >&2
        exit 1
    fi
fi


if [ "$action" = build-vm -o "$action" = build-vm-with-bootloader ]; then
    cat >&2 <<EOF

Done.  The virtual machine can be started by running $(echo $pathToConfig/bin/run-*-vm)
EOF
fi
