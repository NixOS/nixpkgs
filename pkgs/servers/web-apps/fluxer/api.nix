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
}:
let
  nodejs = nodejs_26;
  pnpm = pnpm_11.override { nodejs-slim = nodejs-slim_26; };
  versioning = lib.importJSON ./versioning.json;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fluxer-api";
  inherit (versioning) version;

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    inherit (versioning) rev hash;
  };

  env.npm_config_nodedir = nodejs;

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm
    pnpmConfigHook
    pkg-config
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-B4V0odz6wbmjspaxQ+1Af3TvXR9b6lvwo5LtNs31M8I=";

    pnpmWorkspaces = [ "fluxer_api" ];
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

    makeWrapper ${lib.getExe nodejs} $out/bin/fluxer-api \
      --add-flags "$out/lib/fluxer-api/AppEntrypoint.js" \
      --set "NODE_PATH" $out/lib/node_modules

    makeWrapper ${lib.getExe nodejs} $out/bin/fluxer-api-worker \
      --add-flags "$out/lib/fluxer-api/WorkerEntrypoint.js" \
      --set "NODE_PATH" $out/lib/node_modules

    runHook postInstall
  '';

  meta = {
    description = "A free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Plus;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    mainProgram = "fluxer-api";
  };
})
