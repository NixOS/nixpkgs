{
  fetchPnpmCache,
  lib,
  makeShellWrapper,
  nodejs-slim,
  pnpmCacheConfigHook,
  pnpm_11,
  stdenv,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fetchPnpmCache-simple";
  version = lib.trivial.version;

  src = ./src;

  mitmCache = testers.invalidateFetcherByDrvHash fetchPnpmCache {
    inherit (finalAttrs) pname src;
    hash = "sha256-1fiytx0M1qsn6lNrzKhD6Fjf+6eoWxjtEFLsp8Fo/P8=";
  };

  nativeBuildInputs = [
    makeShellWrapper
    nodejs-slim
    pnpmCacheConfigHook
    pnpm_11
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/lib/pnpm-11-test dist/index.js

    makeWrapper ${lib.getExe nodejs-slim} $out/bin/pnpm-11-test \
      --add-flags "$out/lib/pnpm-11-test"

    runHook postInstall
  '';

  __structuredAttrs = true;
  strictDeps = true;
})
