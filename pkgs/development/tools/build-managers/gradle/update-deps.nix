{ lib
, runtimeShell
, srcOnly
, writeTextFile
, writeShellScript
, path
, bubblewrap
, coreutils
, curl
, jq
, mitm-cache
, nix
, openssl
, procps
, python3
}:

lib.makeOverridable
({ pkg, pname, attrPath, bwrapFlags, data, silent, useBwrap }:
let
  keep = [ "MITM_CACHE_HOST" "MITM_CACHE_PORT" "MITM_CACHE_ADDRESS" "MITM_CACHE_CA" "MITM_CACHE_CERT_DIR" ];
  gradleScript = writeShellScript "gradle-commands.sh" ''
    set -eo pipefail
    export http_proxy="$MITM_CACHE_ADDRESS"
    export https_proxy="$MITM_CACHE_ADDRESS"
    export SSL_CERT_FILE="$MITM_CACHE_CA"
    export NIX_SSL_CERT_FILE="$MITM_CACHE_CA"
    export GRADLE_USER_HOME="$(${coreutils}/bin/mktemp -d)"
    export IN_GRADLE_UPDATE_DEPS=1
    trap "${coreutils}/bin/rm -rf '$GRADLE_USER_HOME'" SIGINT SIGTERM ERR EXIT
    cd "$(${coreutils}/bin/mktemp -d)"
    ${coreutils}/bin/mkdir out
    export out="$PWD/out"
    trap "${coreutils}/bin/rm -rf '$PWD'" SIGINT SIGTERM ERR EXIT
    source "$stdenv/setup"
    phases="''${prePhases[*]:-} unpackPhase patchPhase ''${preConfigurePhases[*]:-} configurePhase gradleUpdateScript" genericBuild
  '';
  source = srcOnly (pkg.overrideAttrs (old: {
    mitmCache = "";
    gradleInitScript = ./init-deps.gradle;
  }));
  sourceDrvPath = builtins.unsafeDiscardOutputDependency source.drvPath;
  nixShellKeep = lib.concatMapStringsSep " " (x: "--keep ${x}") keep;
in
writeTextFile {
  name = "fetch-deps.sh";
  executable = true;
  # see pkgs/common-updater/combinators.nix
  derivationArgs.passthru =
    { supportedFeatures = lib.optional silent "silent"; }
    // lib.optionalAttrs (attrPath != null) { inherit attrPath; };
  text = ''
    #!${runtimeShell}
    set -eo pipefail
    export PATH="${lib.makeBinPath ([
      coreutils curl jq mitm-cache openssl
      procps python3.pkgs.ephemeral-port-reserve
    ] ++ lib.optional useBwrap bubblewrap)}:$PATH"
    outPath="${
      # if this is an absolute path in nix store, use path relative to the store path
      if lib.hasPrefix "${builtins.storeDir}/" (toString data)
      then builtins.concatStringsSep "/" (lib.drop 1 (lib.splitString "/" (lib.removePrefix "${builtins.storeDir}/" (toString data))))
      # if this is an absolute path anywhere else, just use that path
      else if lib.hasPrefix "/" (toString data)
      then toString data
      # otherwise, use a path relative to the package
      else "${dirOf pkg.meta.position}/${data}"
    }"

    pushd "$(mktemp -d)" >/dev/null
    MITM_CACHE_DIR="$PWD"
    trap "rm -rf '$MITM_CACHE_DIR'" SIGINT SIGTERM ERR EXIT
    openssl genrsa -out ca.key 2048
    openssl req -x509 -new -nodes -key ca.key -sha256 -days 1 -out ca.cer -subj "/C=AL/ST=a/L=a/O=a/OU=a/CN=example.org"
    export MITM_CACHE_HOST=127.0.0.1
    export MITM_CACHE_PORT="''${mitmCachePort:-$(ephemeral-port-reserve "$MITM_CACHE_HOST")}"
    export MITM_CACHE_ADDRESS="$MITM_CACHE_HOST:$MITM_CACHE_PORT"
    # forget all redirects - this makes the lockfiles predictable
    # not only does this strip CDN URLs, but it also improves security - since the redirects aren't
    # stored in the lockfile, a malicious actor can't change the redirect URL stored in the lockfile
    mitm-cache \
      -l"$MITM_CACHE_ADDRESS" \
      record \
      --reject '\.(md5|sha(1|256|512:?):?)$' \
      --forget-redirects-from '.*' \
      --record-text '/maven-metadata\.xml$' >/dev/null 2>/dev/null &
    MITM_CACHE_PID="$!"
    # wait for mitm-cache to fully start
    for i in {0..20}; do
      ps -p "$MITM_CACHE_PID" >/dev/null || (echo "Failed to start mitm-cache" && exit 1)
      curl -so/dev/null "$MITM_CACHE_ADDRESS" && break
      [[ "$i" -eq 20 ]] && (echo "Failed to start mitm-cache" && exit 1)
      sleep 0.5
    done
    trap "kill '$MITM_CACHE_PID'" SIGINT SIGTERM ERR EXIT
    export MITM_CACHE_CERT_DIR="$PWD"
    export MITM_CACHE_CA="$MITM_CACHE_CERT_DIR/ca.cer"
    popd >/dev/null
    useBwrap="''${USE_BWRAP:-${toString useBwrap}}"
    if [ -n "$useBwrap" ]; then
      # bwrap isn't necessary, it's only used to prevent messy build scripts from touching ~
      bwrap \
        --unshare-all --share-net --clearenv --chdir / --setenv HOME /homeless-shelter \
        --tmpfs /home --bind /tmp /tmp --ro-bind /nix /nix --ro-bind /run /run --proc /proc --dev /dev  \
        --ro-bind ${toString path} ${toString path} --bind "$MITM_CACHE_CERT_DIR" "$MITM_CACHE_CERT_DIR" \
        ${builtins.concatStringsSep " " (map (x: "--setenv ${x} \"\$${x}\"") keep)} \
        --setenv NIX_BUILD_SHELL ${runtimeShell} ${bwrapFlags} ''${BWRAP_FLAGS:-} \
        -- ${nix}/bin/nix-shell --pure --run ${gradleScript} ${nixShellKeep} ${sourceDrvPath}
    else
      NIX_BUILD_SHELL=${runtimeShell} nix-shell --pure --run ${gradleScript} ${nixShellKeep} ${sourceDrvPath}
    fi${lib.optionalString silent " >&2"}
    kill -s SIGINT "$MITM_CACHE_PID"
    for i in {0..20}; do
      # check for valid json
      if jq -e 1 "$MITM_CACHE_DIR/out.json" >/dev/null 2>/dev/null; then
        exec ${python3.interpreter} ${./compress-deps-json.py} "$MITM_CACHE_DIR/out.json" "$outPath"
      fi
      sleep 1
    done
    exit 1
  '';
})
