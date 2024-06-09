{
  stdenvNoCC,
  fetchurl,
  callPackage,
  jq,
  moreutils,
  cacert,
  makeSetupHook,
  pnpm,
}:
{
  fetchDeps =
    {
      src,
      hash ? "",
      pname,
      ...
    }@args:
    let
      args' = builtins.removeAttrs args [
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
    in
    stdenvNoCC.mkDerivation (finalAttrs: (
      args'
      // {
        name = "${pname}-pnpm-deps";

        nativeBuildInputs = [
          jq
          moreutils
          pnpm
          cacert
        ];

        installPhase = ''
          runHook preInstall

          export HOME=$(mktemp -d)
          pnpm config set store-dir $out
          # Some packages produce platform dependent outputs. We do not want to cache those in the global store
          pnpm config set side-effects-cache false
          # As we pin pnpm versions, we don't really care about updates
          pnpm config set update-notifier false
          # pnpm is going to warn us about using --force
          # --force allows us to fetch all dependencies including ones that aren't meant for our host platform
          pnpm install --frozen-lockfile --ignore-script --force

          runHook postInstall
        '';

        fixupPhase = ''
          runHook preFixup

          # Remove timestamp and sort the json files
          rm -rf $out/v3/tmp
          for f in $(find $out -name "*.json"); do
            jq --sort-keys "del(.. | .checkedAt?)" $f | sponge $f
          done

          runHook postFixup
        '';

        passthru = {
          serve = callPackage ./serve.nix {
            inherit pnpm;
            pnpmDeps = finalAttrs.finalPackage;
          };
        };

        dontConfigure = true;
        dontBuild = true;
        outputHashMode = "recursive";
      }
      // hash'
    ));

  configHook = makeSetupHook {
    name = "pnpm-config-hook";
    propagatedBuildInputs = [ pnpm ];
  } ./pnpm-config-hook.sh;
}
