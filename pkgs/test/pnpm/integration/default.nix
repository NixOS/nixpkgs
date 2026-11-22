{
  fetchPnpmDeps,
  lib,
  makeShellWrapper,
  nodejs-slim,
  pnpmConfigHook,
  stdenv,
  testers,

  pnpm,
  pnpmDepsHash,
  fetcherVersion,
  enableGlobalVirtualStore,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nixpkgs-pnpm-integration-test";
  inherit (pnpm) version;

  src = ./src;

  prePnpmInstall = lib.optionalString enableGlobalVirtualStore ''
    export pnpm_config_enable_global_virtual_store=true
  '';

  pnpmDeps = testers.invalidateFetcherByDrvHash fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      prePnpmInstall
      ;
    inherit pnpm fetcherVersion;
    hash = pnpmDepsHash;
  };

  nativeBuildInputs = [
    makeShellWrapper
    nodejs-slim
    pnpm
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    ${lib.optionalString enableGlobalVirtualStore ''
      if tar --zstd -tf "$pnpmDeps/pnpm-store.tar.zst" \
        | grep -E '^\./v11/links(/|$)'
      then
        echo "pnpmDeps unexpectedly contains the global virtual store" >&2
        exit 1
      fi

      # pnpmConfigHook should recreate the global virtual store offline.
      test -d "$STORE_PATH/v11/links"

      # Package payloads in the global virtual store must remain unchanged.
      echo "e58a1e59497a931067b768651e52eabd8cb5328f4f54023b03988ebb7bfe9579  node_modules/@pnpm/npm-conf/lib/tsconfig.make-out.json" \
        | sha256sum --check
    ''}

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/lib/nixpkgs-pnpm-integration-test dist/index.js

    makeWrapper ${lib.getExe nodejs-slim} $out/bin/nixpkgs-pnpm-integration-test \
      --add-flags "$out/lib/nixpkgs-pnpm-integration-test"

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-pnpm-integration-test";
    inherit (pnpm.meta) maintainers;
  };
})
