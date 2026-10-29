{
  stdenv,
  fetchPnpmDeps,
  pnpm,
  pnpmConfigHook,
  testers,
}:
let
  mkTest =
    { structuredAttrs }:
    stdenv.mkDerivation (finalAttrs: {
      name = "pnpm-workspaces-${if structuredAttrs then "structured" else "legacy"}";

      src = ./src;

      pnpmDeps = testers.invalidateFetcherByDrvHash fetchPnpmDeps {
        pname = "pnpm-workspaces";
        inherit (finalAttrs) src pnpmWorkspaces;
        inherit pnpm;
        fetcherVersion = 4;
        hash = "sha256-dIp6CNh1Kn4aqJWku1G/FUdn/u+epzhqlqwnAkB2uW0=";
      };

      pnpmWorkspaces = [
        "@pnpm-workspaces-test/a"
        "@pnpm-workspaces-test/b"
      ];

      __structuredAttrs = structuredAttrs;

      nativeBuildInputs = [
        pnpm
        pnpmConfigHook
      ];

      buildPhase = ''
        runHook preBuild

        for package in a b; do
          if [ -e "packages/$package/node_modules/@pnpm-workspaces-test/$package-dep" ]; then
            echo "$package was installed (its dependency $package-dep is linked)"
          else
            echo "ERROR: $package was not installed"
            exit 1
          fi
        done

        touch $out

        runHook postBuild
      '';
    });
in
{
  legacy = mkTest { structuredAttrs = false; };
  structured = mkTest { structuredAttrs = true; };
}
