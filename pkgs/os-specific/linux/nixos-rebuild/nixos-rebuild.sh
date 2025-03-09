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
copyFlags=()
extraBuildFlags=()
lockFlags=()
flakeFlags=(--extra-experimental-features 'nix-command flakes')
action=
buildNix=1
fast=
rollback=
upgrade=
upgrade_all=
profile=/nix/var/nix/profiles/system
specialisation=
imageVariant=
buildHost=
targetHost=
remoteSudo=
noSSHTTY=
verboseScript=
noFlake=
attr=
buildFile=default.nix
buildingAttribute=1
installBootloader=
json=

# log the given argument to stderr
log() {
    echo "$@" >&2
}

while [ "$#" -gt 0 ]; do
    i="$1"; shift 1
    case "$i" in
      --help)
        showSyntax
        ;;
      switch|boot|test|build|edit|repl|dry-build|dry-run|dry-activate|build-vm|build-vm-with-bootloader|build-image|list-generations)
        if [ "$i" = dry-run ]; then i=dry-build; fi
        if [ "$i" = list-generations ]; then
            buildNix=
            fast=1
        fi
        # exactly one action mandatory, bail out if multiple are given
        if [ -n "$action" ]; then showSyntax; fi
        action="$i"
        ;;
      --file|-f)
        if [ -z "$1" ]; then
            log "$0: '$i' requires an argument"
            exit 1
        fi
        buildFile="$1"
        buildingAttribute=
        shift 1
        ;;
      --attr|-A)
        if [ -z "$1" ]; then
            log "$0: '$i' requires an argument"
            exit 1
        fi
        attr="$1"
        buildingAttribute=
        shift 1
        ;;
      --install-grub)
        log "$0: --install-grub deprecated, use --install-bootloader instead"
        installBootloader=1
        ;;
      --install-bootloader)
        installBootloader=1
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
      --use-substitutes|--substitute-on-destination|-s)
        copyFlags+=("-s")
        ;;
      -I|--builders)
        j="$1"; shift 1
        extraBuildFlags+=("$i" "$j")
        ;;
      --max-jobs|-j|--cores|--log-format)
        j="$1"; shift 1
        extraBuildFlags+=("$i" "$j")
        copyFlags+=("$i" "$j")
        ;;
      --accept-flake-config|-j*|--quiet|--print-build-logs|-L|--no-build-output|-Q|--show-trace|--refresh|--impure|--offline|--no-net)
        extraBuildFlags+=("$i")
        ;;
      --keep-going|-k|--keep-failed|-K|--fallback|--repair)
        extraBuildFlags+=("$i")
        copyFlags+=("$i")
        ;;
      --verbose|-v|-vv|-vvv|-vvvv|-vvvvv)
        verboseScript="true"
        extraBuildFlags+=("$i")
        copyFlags+=("$i")
        ;;
      --option)
        j="$1"; shift 1
        k="$1"; shift 1
        extraBuildFlags+=("$i" "$j" "$k")
        copyFlags+=("$i" "$j" "$k")
        ;;
      --fast)
        buildNix=
        fast=1
        ;;
      --profile-name|-p)
        if [ -z "$1" ]; then
            log "$0: ‘--profile-name’ requires an argument"
            exit 1
        fi
        if [ "$1" != system ]; then
            profile="/nix/var/nix/profiles/system-profiles/$1"
            (umask 022 && mkdir -p "$(dirname "$profile")")
        fi
        shift 1
        ;;
      --specialisation|-c)
        if [ -z "$1" ]; then
            log "$0: ‘--specialisation’ requires an argument"
            exit 1
        fi
        specialisation="$1"
        shift 1
        ;;
      --image-variant)
        if [ -z "$1" ]; then
            log "$0: ‘--image-variant’ requires an argument"
            exit 1
        fi
        imageVariant="$1"
        shift 1
        ;;
      --build-host)
        buildHost="$1"
        shift 1
        ;;
      --target-host)
        targetHost="$1"
        shift 1
        ;;
      --use-remote-sudo)
        remoteSudo=1
        ;;
      --no-ssh-tty)
        noSSHTTY=1
        ;;
      --flake)
        flake="$1"
        shift 1
        ;;
      --no-flake)
        noFlake=1
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
      --json)
        json=1
        ;;
      *)
        log "$0: unknown option \`$i'"
        exit 1
        ;;
    esac
done

# log the given argument to stderr if verbose mode is on
logVerbose() {
    if [ -n "$verboseScript" ]; then
      echo "$@" >&2
    fi
}

# Run a command, logging it first if verbose mode is on
runCmd() {
    logVerbose "$" "$@"
    "$@"
}

buildHostCmd() {
    local c
    if [[ "${useSudo:-x}" = 1 ]]; then
        c=("sudo")
    else
        c=()
    fi

    if [ -z "$buildHost" ]; then
        runCmd "$@"
    elif [ -n "$remoteNix" ]; then
        runCmd ssh $SSHOPTS "$buildHost" "${c[@]}" env PATH="$remoteNix":'$PATH' "$@"
    else
        runCmd ssh $SSHOPTS "$buildHost" "${c[@]}" "$@"
    fi
}

targetHostCmd() {
    local c
    if [[ "${useSudo:-x}" = 1 ]]; then
        c=("sudo")
    else
        c=()
    fi

    if [ -z "$targetHost" ]; then
        runCmd "${c[@]}" "$@"
    else
        runCmd ssh $SSHOPTS "$targetHost" "${c[@]}" "$@"
    fi
}

targetHostSudoCmd() {
    local t=
    if [[ ! "${noSSHTTY:-x}" = 1 ]]; then
        t="-t"
    fi

    if [ -n "$remoteSudo" ]; then
        useSudo=1 SSHOPTS="$SSHOPTS $t" targetHostCmd "$@"
    else
        # While a tty might not be necessary, we apply it to be consistent with
        # sudo usage, and an experience that is more consistent with local deployment.
        # But if the user really doesn't want it, don't do it.
        SSHOPTS="$SSHOPTS $t" targetHostCmd "$@"
    fi
}

copyToTarget() {
    if ! [ "$targetHost" = "$buildHost" ]; then
        if [ -z "$targetHost" ]; then
            logVerbose "Running nix-copy-closure with these NIX_SSHOPTS: $SSHOPTS"
            NIX_SSHOPTS=$SSHOPTS runCmd nix-copy-closure "${copyFlags[@]}" --from "$buildHost" "$1"
        elif [ -z "$buildHost" ]; then
            logVerbose "Running nix-copy-closure with these NIX_SSHOPTS: $SSHOPTS"
            NIX_SSHOPTS=$SSHOPTS runCmd nix-copy-closure "${copyFlags[@]}" --to "$targetHost" "$1"
        else
            buildHostCmd nix-copy-closure "${copyFlags[@]}" --to "$targetHost" "$1"
        fi
    fi
}

nixBuild() {
    logVerbose "Building in legacy (non-flake) mode."
    if [ -z "$buildHost" ]; then
        logVerbose "No --build-host given, running nix-build locally"
        runCmd nix-build "$@"
    else
        logVerbose "buildHost set to \"$buildHost\", running nix-build remotely"
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

        if [[ -z $buildingAttribute ]]; then
            instArgs+=("$buildFile")
        fi

        drv="$(runCmd nix-instantiate "${instArgs[@]}" "${extraBuildFlags[@]}")"
        if [ -a "$drv" ]; then
            logVerbose "Running nix-copy-closure with these NIX_SSHOPTS: $SSHOPTS"
            NIX_SSHOPTS=$SSHOPTS runCmd nix-copy-closure --to "$buildHost" "$drv"
            buildHostCmd nix-store -r "$drv" "${buildArgs[@]}"
        else
            log "nix-instantiate failed"
            exit 1
        fi
  fi
}

nixFlakeBuild() {
    logVerbose "Building in flake mode."
    if [[ -z "$buildHost" && -z "$targetHost" && "$action" != switch && "$action" != boot && "$action" != test && "$action" != dry-activate ]]
    then
        runCmd nix "${flakeFlags[@]}" build "$@"
        readlink -f ./result
    elif [ -z "$buildHost" ]; then
        runCmd nix "${flakeFlags[@]}" build "$@" --out-link "${tmpDir}/result"
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
              --impure) # We don't want this in buildArgs, it's only needed at evaluation time, and unsupported during realisation
                ;;
              *)
                buildArgs+=("$i")
                ;;
            esac
        done

        drv="$(runCmd nix "${flakeFlags[@]}" eval --raw "${attr}.drvPath" "${evalArgs[@]}" "${extraBuildFlags[@]}")"
        if [ -a "$drv" ]; then
            logVerbose "Running nix with these NIX_SSHOPTS: $SSHOPTS"
            NIX_SSHOPTS=$SSHOPTS runCmd nix "${flakeFlags[@]}" copy "${copyFlags[@]}" --derivation --to "ssh://$buildHost" "$drv"
            buildHostCmd nix-store -r "$drv" "${buildArgs[@]}"
        else
            log "nix eval failed"
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
if [[ "$action" = switch || "$action" = boot || "$action" = test ]]; then
    canRun=1
fi

# Verify that user is not trying to use attribute building and flake
# at the same time
if [[ -z $buildingAttribute && -n $flake ]]; then
    log "error: '--flake' cannot be used with '--file' or '--attr'"
    exit 1
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
            runCmd nix-channel --update "$channel_name"
        elif [ -e "$channelpath/.update-on-nixos-rebuild" ]; then
            runCmd nix-channel --update "$channel_name"
        elif [[ -n $upgrade_all ]] ; then
            runCmd nix-channel --update "$channel_name"
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
if [[ -z $flake && -e /etc/nixos/flake.nix && -z $noFlake ]]; then
    flake="$(dirname "$(readlink -f /etc/nixos/flake.nix)")"
fi

tmpDir=$(mktemp -t -d nixos-rebuild.XXXXXX)

if [[ ${#tmpDir} -ge 60 ]]; then
    # Very long tmp dirs lead to "too long for Unix domain socket"
    # SSH ControlPath errors. Especially macOS sets long TMPDIR paths.
    rmdir "$tmpDir"
    tmpDir=$(TMPDIR= mktemp -t -d nixos-rebuild.XXXXXX)
fi

cleanup() {
    for ctrl in "$tmpDir"/ssh-*; do
        ssh -o ControlPath="$ctrl" -O exit dummyhost 2>/dev/null || true
    done
    rm -rf "$tmpDir"
}
trap cleanup EXIT

SSHOPTS="$NIX_SSHOPTS -o ControlMaster=auto -o ControlPath=$tmpDir/ssh-%n -o ControlPersist=60"

# For convenience, use the hostname as the default configuration to
# build from the flake.
if [[ -n $flake ]]; then
    if [[ $flake =~ ^(.*)\#([^\#\"]*)$ ]]; then
       flake="${BASH_REMATCH[1]}"
       flakeAttr="${BASH_REMATCH[2]}"
    fi
    if [[ -z $flakeAttr ]]; then
        hostname="$(targetHostCmd cat /proc/sys/kernel/hostname)"
        if [[ -z $hostname ]]; then
            hostname=default
        fi
        flakeAttr="nixosConfigurations.\"$hostname\""
    else
        flakeAttr="nixosConfigurations.\"$flakeAttr\""
    fi
fi

if [[ ! -z "$specialisation" && ! "$action" = switch && ! "$action" = test ]]; then
    log "error: ‘--specialisation’ can only be used with ‘switch’ and ‘test’"
    exit 1
fi


# Re-execute nixos-rebuild from the Nixpkgs tree.
if [[ -z $_NIXOS_REBUILD_REEXEC && -n $canRun && -z $fast ]]; then
    if [[ -z $buildingAttribute ]]; then
        p=$(runCmd nix-build --no-out-link $buildFile -A "${attr:+$attr.}config.system.build.nixos-rebuild" "${extraBuildFlags[@]}")
        SHOULD_REEXEC=1
    elif [[ -z $flake ]]; then
        if p=$(runCmd nix-build --no-out-link --expr 'with import <nixpkgs/nixos> {}; config.system.build.nixos-rebuild' "${extraBuildFlags[@]}"); then
            SHOULD_REEXEC=1
        fi
    else
        runCmd nix "${flakeFlags[@]}" build --out-link "${tmpDir}/nixos-rebuild" "$flake#$flakeAttr.config.system.build.nixos-rebuild" "${extraBuildFlags[@]}" "${lockFlags[@]}"
        if p=$(readlink -e "${tmpDir}/nixos-rebuild"); then
            SHOULD_REEXEC=1
        fi
    fi

    if [[ -n $SHOULD_REEXEC ]]; then
        export _NIXOS_REBUILD_REEXEC=1
        # Manually call cleanup as the EXIT trap is not triggered when using exec
        cleanup
        runCmd exec "$p/bin/nixos-rebuild" "${origArgs[@]}"
        exit 1
    fi
fi

# Find configuration.nix and open editor instead of building.
if [ "$action" = edit ]; then
    if [[ -z $buildingAttribute ]]; then
        log "error: '--file' and '--attr' are not supported with 'edit'"
        exit 1
    elif [[ -z $flake ]]; then
        NIXOS_CONFIG=${NIXOS_CONFIG:-$(runCmd nix-instantiate --find-file nixos-config)}
        if [[ -d $NIXOS_CONFIG ]]; then
            NIXOS_CONFIG=$NIXOS_CONFIG/default.nix
        fi
        runCmd exec ${EDITOR:-nano} "$NIXOS_CONFIG"
    else
        runCmd exec nix "${flakeFlags[@]}" edit "${lockFlags[@]}" -- "$flake#$flakeAttr"
    fi
    exit 1
fi

# First build Nix, since NixOS may require a newer version than the
# current one.
if [[ -n "$rollback" || "$action" = dry-build ]]; then
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
        log "$0: unsupported platform"
        exit 1
    fi
}

getNixDrv() {
    nixDrv=

    if [[ -z $buildingAttribute ]]; then
        if nixDrv="$(runCmd nix-instantiate $buildFile --add-root "$tmpDir/nix.drv" --indirect -A ${attr:+$attr.}config.nix.package.out "${extraBuildFlags[@]}")"; then return; fi
    fi
    if nixDrv="$(runCmd nix-instantiate '<nixpkgs/nixos>' --add-root "$tmpDir/nix.drv" --indirect -A config.nix.package.out "${extraBuildFlags[@]}")"; then return; fi
    if nixDrv="$(runCmd nix-instantiate '<nixpkgs>' --add-root "$tmpDir/nix.drv" --indirect -A nix "${extraBuildFlags[@]}")"; then return; fi

    if ! nixStorePath="$(runCmd nix-instantiate --eval '<nixpkgs/nixos/modules/installer/tools/nix-fallback-paths.nix>' -A "$(nixSystem)" | sed -e 's/^"//' -e 's/"$//')"; then
        nixStorePath="$(prebuiltNix "$(uname -m)")"
    fi
    if ! runCmd nix-store -r "$nixStorePath" --add-root "${tmpDir}/nix" --indirect \
        --option extra-binary-caches https://cache.nixos.org/; then
        log "warning: don't know how to get latest Nix"
    fi
    # Older version of nix-store -r don't support --add-root.
    [ -e "$tmpDir/nix" ] || ln -sf "$nixStorePath" "$tmpDir/nix"
    if [ -n "$buildHost" ]; then
        remoteNixStorePath="$(runCmd prebuiltNix "$(buildHostCmd uname -m)")"
        remoteNix="$remoteNixStorePath/bin"
        if ! buildHostCmd nix-store -r "$remoteNixStorePath" \
          --option extra-binary-caches https://cache.nixos.org/ >/dev/null; then
            remoteNix=
            log "warning: don't know how to get latest Nix"
        fi
    fi
}

getVersion() {
    local dir="$1"
    local rev=
    local gitDir="$dir/.git"
    if [ -e "$gitDir" ]; then
        if [ -z "$(type -P git)" ]; then
            echo "warning: Git not found; cannot figure out revision of $dir" >&2
            return
        fi
        cd "$dir"
        rev=$(git --git-dir="$gitDir" rev-parse --short HEAD)
        if git --git-dir="$gitDir" describe --always --dirty | grep -q dirty; then
            rev+=M
        fi
    fi

    if [ -n "$rev" ]; then
        echo ".git.$rev"
    fi
}


if [[ -n $buildNix && -z $flake ]]; then
    log "building Nix..."
    getNixDrv
    if [ -a "$nixDrv" ]; then
        nix-store -r "$nixDrv"'!'"out" --add-root "$tmpDir/nix" --indirect >/dev/null
        if [ -n "$buildHost" ]; then
            nix-copy-closure "${copyFlags[@]}" --to "$buildHost" "$nixDrv"
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
    if nixpkgs=$(runCmd nix-instantiate --find-file nixpkgs "${extraBuildFlags[@]}"); then
        suffix=$(getVersion "$nixpkgs" || true)
        if [ -n "$suffix" ]; then
            echo -n "$suffix" > "$nixpkgs/.version-suffix" || true
        fi
    fi
fi


if [ "$action" = dry-build ]; then
    extraBuildFlags+=(--dry-run)
fi

if [ "$action" = repl ]; then
    # This is a very end user command, implemented using sub-optimal means.
    # You should feel free to improve its behavior, as well as resolve tech
    # debt in "breaking" ways. Humans adapt quite well.
    if [[ -z $buildingAttribute ]]; then
        exec nix repl --file $buildFile $attr "${extraBuildFlags[@]}"
    elif [[ -z $flake ]]; then
        exec nix repl --file '<nixpkgs/nixos>' "${extraBuildFlags[@]}"
    else
        if [[ -n "${lockFlags[0]}" ]]; then
            # nix repl itself does not support locking flags
            log "nixos-rebuild repl does not support locking flags yet"
            exit 1
        fi
        d='$'
        q='"'
        bold="$(echo -e '\033[1m')"
        blue="$(echo -e '\033[34;1m')"
        attention="$(echo -e '\033[35;1m')"
        reset="$(echo -e '\033[0m')"
        if [[ -e $flake ]]; then
            flakePath=$(realpath "$flake")
        else
            flakePath=$flake
        fi
        # This nix repl invocation is impure, because usually the flakeref is.
        # For a solution that preserves the motd and custom scope, we need
        # something like https://github.com/NixOS/nix/issues/8679.
        exec nix repl --impure --expr "
          let flake = builtins.getFlake ''$flakePath'';
              configuration = flake.$flakeAttr;
              motd = ''
                $d{$q\n$q}
                Hello and welcome to the NixOS configuration
                    $flakeAttr
                    in $flake

                The following is loaded into nix repl's scope:

                    - ${blue}config${reset}   All option values
                    - ${blue}options${reset}  Option data and metadata
                    - ${blue}pkgs${reset}     Nixpkgs package set
                    - ${blue}lib${reset}      Nixpkgs library functions
                    - other module arguments

                    - ${blue}flake${reset}    Flake outputs, inputs and source info of $flake

                Use tab completion to browse around ${blue}config${reset}.

                Use ${bold}:r${reset} to ${bold}reload${reset} everything after making a change in the flake.
                  (assuming $flake is a mutable flake ref)

                See ${bold}:?${reset} for more repl commands.

                ${attention}warning:${reset} nixos-rebuild repl does not currently enforce pure evaluation.
              '';
              scope =
                assert configuration._type or null == ''configuration'';
                assert configuration.class or ''nixos'' == ''nixos'';
                configuration._module.args //
                configuration._module.specialArgs //
                {
                  inherit (configuration) config options;
                  lib = configuration.lib or configuration.pkgs.lib;
                  inherit flake;
                };
          in builtins.seq scope builtins.trace motd scope
        " "${extraBuildFlags[@]}"
    fi
fi

if [ "$action" = list-generations ]; then
    if [ ! -L "$profile" ]; then
        log "No profile \`$(basename "$profile")' found"
        exit 1
    fi

    generation_from_dir() {
        generation_dir="$1"
        generation_base="$(basename "$generation_dir")" # Has the format "system-123-link" for generation 123
        no_link_gen="${generation_base%-link}"  # remove the "-link"
        echo "${no_link_gen##*-}" # remove everything before the last dash
    }
    describe_generation(){
        generation_dir="$1"
        generation_number="$(generation_from_dir "$generation_dir")"
        nixos_version="$(cat "$generation_dir/nixos-version" 2> /dev/null || echo "Unknown")"

        kernel_dir="$(dirname "$(realpath "$generation_dir/kernel")")"
        kernel_version="$(ls "$kernel_dir/lib/modules" || echo "Unknown")"

        configurationRevision="$("$generation_dir/sw/bin/nixos-version" --configuration-revision 2> /dev/null || true)"

        # Old nixos-version output ignored unknown flags and just printed the version
        # therefore the following workaround is done not to show the default output
        nixos_version_default="$("$generation_dir/sw/bin/nixos-version")"
        if [ "$configurationRevision" == "$nixos_version_default" ]; then
             configurationRevision=""
        fi

        # jq automatically quotes the output => don't try to quote it in output!
        build_date="$(stat "$generation_dir" --format=%W | jq 'todate')"

        pushd "$generation_dir/specialisation/" > /dev/null || :
        specialisation_list=(*)
        popd > /dev/null || :

        specialisations="$(jq --compact-output --null-input '$ARGS.positional' --args -- "${specialisation_list[@]}")"

        if [ "$(basename "$generation_dir")" = "$(readlink "$profile")" ]; then
            current_generation_tag="true"
        else
            current_generation_tag="false"
        fi

        # Escape userdefined strings
        nixos_version="$(jq -aR <<< "$nixos_version")"
        kernel_version="$(jq -aR <<< "$kernel_version")"
        configurationRevision="$(jq -aR <<< "$configurationRevision")"
        cat << EOF
{
  "generation": $generation_number,
  "date": $build_date,
  "nixosVersion": $nixos_version,
  "kernelVersion": $kernel_version,
  "configurationRevision": $configurationRevision,
  "specialisations": $specialisations,
  "current": $current_generation_tag
}
EOF
    }

    find "$(dirname "$profile")" -regex "$profile-[0-9]+-link" |
        sort -Vr |
        while read -r generation_dir; do
            describe_generation "$generation_dir"
        done |
        if [ -z "$json" ]; then
            jq --slurp -r '.[] | [
                    ([.generation, (if .current == true then "current" else "" end)] | join(" ")),
                    (.date | fromdate | strflocaltime("%Y-%m-%d %H:%M:%S")),
                    .nixosVersion, .kernelVersion, .configurationRevision,
                    (.specialisations | join(" "))
                ] | @tsv' |
                column --separator $'\t' --table --table-columns "Generation,Build-date,NixOS version,Kernel,Configuration Revision,Specialisation"
        else
            jq --slurp .
        fi
    exit 0
fi


# Either upgrade the configuration in the system profile (for "switch"
# or "boot"), or just build it and create a symlink "result" in the
# current directory (for "build" and "test").
if [ -z "$rollback" ]; then
    log "building the system configuration..."
    if [[ "$action" = switch || "$action" = boot ]]; then
        if [[ -z $buildingAttribute ]]; then
            pathToConfig="$(nixBuild $buildFile -A "${attr:+$attr.}config.system.build.toplevel" "${extraBuildFlags[@]}")"
        elif [[ -z $flake ]]; then
            pathToConfig="$(nixBuild '<nixpkgs/nixos>' --no-out-link -A system "${extraBuildFlags[@]}")"
        else
            pathToConfig="$(nixFlakeBuild "$flake#$flakeAttr.config.system.build.toplevel" "${extraBuildFlags[@]}" "${lockFlags[@]}")"
        fi
        copyToTarget "$pathToConfig"
        targetHostSudoCmd nix-env -p "$profile" --set "$pathToConfig"
    elif [[ "$action" = test || "$action" = build || "$action" = dry-build || "$action" = dry-activate ]]; then
        if [[ -z $buildingAttribute ]]; then
            pathToConfig="$(nixBuild $buildFile -A "${attr:+$attr.}config.system.build.toplevel" "${extraBuildFlags[@]}")"
        elif [[ -z $flake ]]; then
            pathToConfig="$(nixBuild '<nixpkgs/nixos>' -A system -k "${extraBuildFlags[@]}")"
        else
            pathToConfig="$(nixFlakeBuild "$flake#$flakeAttr.config.system.build.toplevel" "${extraBuildFlags[@]}" "${lockFlags[@]}")"
        fi
    elif [ "$action" = build-vm ]; then
        if [[ -z $buildingAttribute ]]; then
            pathToConfig="$(nixBuild $buildFile -A "${attr:+$attr.}config.system.build.vm" "${extraBuildFlags[@]}")"
        elif [[ -z $flake ]]; then
            pathToConfig="$(nixBuild '<nixpkgs/nixos>' -A vm -k "${extraBuildFlags[@]}")"
        else
            pathToConfig="$(nixFlakeBuild "$flake#$flakeAttr.config.system.build.vm" "${extraBuildFlags[@]}" "${lockFlags[@]}")"
        fi
    elif [ "$action" = build-vm-with-bootloader ]; then
        if [[ -z $buildingAttribute ]]; then
            pathToConfig="$(nixBuild $buildFile -A "${attr:+$attr.}config.system.build.vmWithBootLoader" "${extraBuildFlags[@]}")"
        elif [[ -z $flake ]]; then
            pathToConfig="$(nixBuild '<nixpkgs/nixos>' -A vmWithBootLoader -k "${extraBuildFlags[@]}")"
        else
            pathToConfig="$(nixFlakeBuild "$flake#$flakeAttr.config.system.build.vmWithBootLoader" "${extraBuildFlags[@]}" "${lockFlags[@]}")"
        fi
    elif [ "$action" = build-image ]; then
        if [[ -z $buildingAttribute ]]; then
            variants="$(
                runCmd nix-instantiate --eval --strict --json --expr \
                "let
                    value = import \"$(realpath $buildFile)\";
                    set = if builtins.isFunction value then value {} else value;
                in builtins.mapAttrs (n: v: v.passthru.filePath) set.${attr:+$attr.}config.system.build.images" \
                "${extraBuildFlags[@]}"
            )"
        elif [[ -z $flake ]]; then
            variants="$(
                runCmd nix-instantiate --eval --strict --json --expr \
                "with import <nixpkgs/nixos> {}; builtins.mapAttrs (n: v: v.passthru.filePath) config.system.build.images" \
                "${extraBuildFlags[@]}"
            )"
        else
            variants="$(
                runCmd nix "${flakeFlags[@]}" eval --json \
                "$flake#$flakeAttr.config.system.build.images" \
                --apply "builtins.mapAttrs (n: v: v.passthru.filePath)" "${evalArgs[@]}" "${extraBuildFlags[@]}"
            )"
        fi
        if ! echo "$variants" | jq -e --arg variant "$imageVariant" "keys | any(. == \$variant)" > /dev/null; then
            echo -e "Please specify one of the following supported image variants via --image-variant:\n" >&2
            echo "$variants" | jq -r '. | keys | join ("\n")'
            exit 1
        fi
        imageName="$(echo "$variants" | jq -r --arg variant "$imageVariant" ".[\$variant]")"

        if [[ -z $buildingAttribute ]]; then
            pathToConfig="$(nixBuild $buildFile -A "${attr:+$attr.}config.system.build.images.${imageVariant}" "${extraBuildFlags[@]}")"
        elif [[ -z $flake ]]; then
            pathToConfig="$(nixBuild '<nixpkgs/nixos>' -A config.system.build.images.${imageVariant} -k "${extraBuildFlags[@]}")"
        else
            pathToConfig="$(nixFlakeBuild "$flake#$flakeAttr.config.system.build.images.${imageVariant}" "${extraBuildFlags[@]}" "${lockFlags[@]}")"
        fi
    else
        showSyntax
    fi
    # Copy build to target host if we haven't already done it
    if ! [[ "$action" = switch || "$action" = boot ]]; then
        copyToTarget "$pathToConfig"
    fi
else # [ -n "$rollback" ]
    if [[ "$action" = switch || "$action" = boot ]]; then
        targetHostSudoCmd nix-env --rollback -p "$profile"
        pathToConfig="$profile"
    elif [[ "$action" = test || "$action" = build ]]; then
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
if [[ "$action" = switch || "$action" = boot || "$action" = test || "$action" = dry-activate ]]; then
    # Using systemd-run here to protect against PTY failures/network
    # disconnections during rebuild.
    # See: https://github.com/NixOS/nixpkgs/issues/39118
    cmd=(
        "systemd-run"
        "-E" "LOCALE_ARCHIVE" # Will be set to new value early in switch-to-configuration script, but interpreter starts out with old value
        "-E" "NIXOS_INSTALL_BOOTLOADER=$installBootloader"
        "--collect"
        "--no-ask-password"
        "--pipe"
        "--quiet"
        "--service-type=exec"
        "--unit=nixos-rebuild-switch-to-configuration"
        "--wait"
    )
    # Check if we have a working systemd-run. In chroot environments we may have
    # a non-working systemd, so we fallback to not using systemd-run.
    # You may also want to explicitly set NIXOS_SWITCH_USE_DIRTY_ENV environment
    # variable, since systemd-run runs inside an isolated environment and
    # this may break some post-switch scripts. However keep in mind that this
    # may be dangerous in remote access (e.g. SSH).
    if [[ -n "$NIXOS_SWITCH_USE_DIRTY_ENV" ]]; then
        log "warning: skipping systemd-run since NIXOS_SWITCH_USE_DIRTY_ENV is set. This environment variable will be ignored in the future"
        cmd=("env" "NIXOS_INSTALL_BOOTLOADER=$installBootloader")
    elif ! targetHostSudoCmd "${cmd[@]}" true; then
        logVerbose "Skipping systemd-run to switch configuration since it is not working in target host."
        cmd=(
            "env"
            "-i"
            "LOCALE_ARCHIVE=$LOCALE_ARCHIVE"
            "NIXOS_INSTALL_BOOTLOADER=$installBootloader"
        )
    else
        logVerbose "Using systemd-run to switch configuration."
    fi
    if [[ -z "$specialisation" ]]; then
        cmd+=("$pathToConfig/bin/switch-to-configuration")
    else
        cmd+=("$pathToConfig/specialisation/$specialisation/bin/switch-to-configuration")

        if [ -z "$targetHost" ]; then
            specialisationExists=$(test -f "${cmd[-1]}")
        else
            specialisationExists=$(targetHostCmd test -f "${cmd[-1]}")
        fi

        if ! $specialisationExists; then
            log "error: specialisation not found: $specialisation"
            exit 1
        fi
    fi

    if ! targetHostSudoCmd "${cmd[@]}" "$action"; then
        log "warning: error(s) occurred while switching to the new configuration"
        exit 1
    fi
fi


if [[ "$action" = build-vm || "$action" = build-vm-with-bootloader ]]; then
    cat >&2 <<EOF

Done.  The virtual machine can be started by running $(echo "${pathToConfig}/bin/"run-*-vm)
EOF
fi

if [[ "$action" = build-image ]]; then
    echo -n "Done.  The disk image can be found in " >&2
    echo "${pathToConfig}/${imageName}"
fi
