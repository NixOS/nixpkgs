{
  lib,
  stdenvNoCC,
  callPackage,
  jq,
  moreutils,
  cacert,
  makeSetupHook,
  pnpm,
  yq,
}:

let
  pnpm' = pnpm;

  supportedFetcherVersions = [
    1 # First version. Here to preserve backwards compatibility
    2 # Ensure consistent permissions. See https://github.com/NixOS/nixpkgs/pull/422975
  ];
in
{
  fetchDeps = lib.makeOverridable (
    {
      hash ? "",
      pname,
      pnpm ? pnpm',
      pnpmWorkspaces ? [ ],
      prePnpmInstall ? "",
      pnpmInstallFlags ? [ ],
      fetcherVersion ? null,
      ...
    }@args:
    let
      args' = removeAttrs args [
        "hash"
        "pname"
      ];
      hash' =
        if hash != "" then
          { outputHash = hash; }
        else
          {
            outputHash = "";
            outputHashAlgo = "sha256";
          };

      filterFlags = lib.map (package: "--filter=${package}") pnpmWorkspaces;
    in
    # pnpmWorkspace was deprecated, so throw if it's used.
    assert (lib.throwIf (args ? pnpmWorkspace)
      "pnpm.fetchDeps: `pnpmWorkspace` is no longer supported, please migrate to `pnpmWorkspaces`."
    ) true;

    assert (lib.throwIf (fetcherVersion == null)
      "pnpm.fetchDeps: `fetcherVersion` is not set, see https://nixos.org/manual/nixpkgs/stable/#javascript-pnpm-fetcherVersion."
    ) true;

    assert (lib.throwIf (!(builtins.elem fetcherVersion supportedFetcherVersions))
      "pnpm.fetchDeps `fetcherVersion` is not set to a supported value (${lib.concatStringsSep ", " (map toString supportedFetcherVersions)}), see https://nixos.org/manual/nixpkgs/stable/#javascript-pnpm-fetcherVersion."
    ) true;

    stdenvNoCC.mkDerivation (
      finalAttrs:
      (
        args'
        // {
          name = "${pname}-pnpm-deps";

          nativeBuildInputs = [
            cacert
            jq
            moreutils
            args.pnpm or pnpm'
            yq
          ];

          impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [ "NIX_NPM_REGISTRY" ];

          installPhase = ''
            runHook preInstall

            lockfileVersion="$(yq -r .lockfileVersion pnpm-lock.yaml)"
            if [[ ''${lockfileVersion:0:1} -gt ${lib.versions.major pnpm.version} ]]; then
              echo "ERROR: lockfileVersion $lockfileVersion in pnpm-lock.yaml is too new for the provided pnpm version ${lib.versions.major pnpm.version}!"
              exit 1
            fi

            export HOME=$(mktemp -d)

            # If the packageManager field in package.json is set to a different pnpm version than what is in nixpkgs,
            # any pnpm command would fail in that directory, the following disables this
            pushd ..
            pnpm config set manage-package-manager-versions false
            popd

            pnpm config set store-dir $out
            # Some packages produce platform dependent outputs. We do not want to cache those in the global store
            pnpm config set side-effects-cache false
            # As we pin pnpm versions, we don't really care about updates
            pnpm config set update-notifier false
            # Run any additional pnpm configuration commands that users provide.
            ${prePnpmInstall}
            # pnpm is going to warn us about using --force
            # --force allows us to fetch all dependencies including ones that aren't meant for our host platform
            pnpm install \
                --force \
                --ignore-scripts \
                ${lib.escapeShellArgs filterFlags} \
                ${lib.escapeShellArgs pnpmInstallFlags} \
                --registry="$NIX_NPM_REGISTRY" \
                --frozen-lockfile

            # Store newer fetcherVersion in case pnpm.configHook also needs it
            if [[ ${toString fetcherVersion} -gt 1 ]]; then
              echo ${toString fetcherVersion} > $out/.fetcher-version
            fi

            runHook postInstall
          '';

          fixupPhase = ''
            runHook preFixup

            # Remove timestamp and sort the json files
            rm -rf $out/{v3,v10}/tmp
            for f in $(find $out -name "*.json"); do
              jq --sort-keys "del(.. | .checkedAt?)" $f | sponge $f
            done

            # Ensure consistent permissions
            # NOTE: For reasons not yet fully understood, pnpm might create files with
            # inconsistent permissions, for example inside the ubuntu-24.04
            # github actions runner.
            # To ensure stable derivations, we need to set permissions
            # consistently, namely:
            # * All files with `-exec` suffix have 555.
            # * All other files have 444.
            # * All folders have 555.
            # See https://github.com/NixOS/nixpkgs/pull/350063
            # See https://github.com/NixOS/nixpkgs/issues/422889
            if [[ ${toString fetcherVersion} -ge 2 ]]; then
              find $out -type f -name "*-exec" -print0 | xargs -0 chmod 555
              find $out -type f -not -name "*-exec" -print0 | xargs -0 chmod 444
              find $out -type d -print0 | xargs -0 chmod 555
            fi

            runHook postFixup
          '';

          passthru = {
            inherit fetcherVersion;
            serve = callPackage ./serve.nix {
              pnpm = args.pnpm or pnpm';
              pnpmDeps = finalAttrs.finalPackage;
            };
          };

          dontConfigure = true;
          dontBuild = true;
          outputHashMode = "recursive";
        }
        // hash'
      )
    )
  );

  configHook = makeSetupHook {
    name = "pnpm-config-hook";
    propagatedBuildInputs = [ pnpm ];
    substitutions = {
      npmArch = stdenvNoCC.targetPlatform.node.arch;
      npmPlatform = stdenvNoCC.targetPlatform.node.platform;
    };
  } ./pnpm-config-hook.sh;
}
