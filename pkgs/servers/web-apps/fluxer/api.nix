{
  stdenv,
  pnpm_11,
  nodejs_26,
  nodejs-slim_26,
  pkg-config,
  pnpmConfigHook,
  makeBinaryWrapper,
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  fluxerHashes,
}:
let
  nodejs = nodejs_26;
  pnpm = pnpm_11.override { nodejs-slim = nodejs-slim_26; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fluxer-api";
  inherit (fluxerHashes) version;

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    inherit (fluxerHashes) rev hash;
  };

  env.npm_config_nodedir = nodejs;

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm
    pnpmConfigHook
    pkg-config
  ];

  pnpmWorkspaces = [ "fluxer_api..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = fluxerHashes.pnpm.api;
  };

  buildPhase = ''
    runHook preBuild

    pnpm --filter fluxer_api run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    pnpm config set --location=project injectWorkspacePackages true
    pnpm deploy \
      --filter=fluxer_api \
      --prod \
      $out/lib

    mkdir -p $out/lib/fluxer-api
    cp -r fluxer_api/dist/* $out/lib/fluxer-api/

    cat >$out/bin/fluxer-api <<EOF
    NODE_PATH="$out/lib/node_modules"
    ${lib.getExe nodejs} "$out/lib/fluxer-api/AppEntrypoint.js"
    EOF

    cat >$out/bin/fluxer-api-worker <<EOF
    NODE_PATH="$out/lib/node_modules"
    ${lib.getExe nodejs} "$out/lib/fluxer-api/WorkerEntrypoint.js"
    EOF

    runHook postInstall
  '';

  meta = {
    description = "HTTP API and background workers for Fluxer, a free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Plus;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    mainProgram = "fluxer-api";
  };
})
