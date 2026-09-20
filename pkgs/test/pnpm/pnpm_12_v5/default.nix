{
  fetchPnpmDeps,
  lib,
  makeShellWrapper,
  nodejs-slim,
  pnpmConfigHook,
  pnpm_12,
  stdenv,
  testers,
}:
let
  pnpm = pnpm_12;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pnpm-test";
  inherit (pnpm) version;

  src = ./src;

  pnpmDeps = testers.invalidateFetcherByDrvHash fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-EXbS1aETXxzbq3dBb+G/pjjlk+JIXFtcjir4ai0d5DM=";
  };

  nativeBuildInputs = [
    makeShellWrapper
    nodejs-slim
    pnpm
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

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

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/lib/pnpm-12-test dist/index.js

    makeWrapper ${lib.getExe nodejs-slim} $out/bin/pnpm-12-test \
      --add-flags "$out/lib/pnpm-12-test"

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    license = lib.licenses.mit;
    mainProgram = "pnpm-12-test";
    inherit (pnpm.meta) maintainers;
  };
})
