{ lib
, buildNpmPackage
, fetchFromGitHub
, git
, nixosTests
, python311
, vaultwarden
}:

let
  version = "2024.6.2b";

  bw_web_builds = fetchFromGitHub {
    owner = "dani-garcia";
    repo = "bw_web_builds";
    rev = "v${version}";
    hash = "sha256-Gcn/TOXdhMqGq4NTCPQTTEvN5rOQS3LImPUYBsv8de8=";
  };

in buildNpmPackage rec {
  pname = "vaultwarden-webvault";
  inherit version;

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "web-v${lib.removeSuffix "b" version}";
    hash = "sha256-HMQ0oQ04WkLlUgsYt6ZpcziDq05mnSA0+VnJCpteceg=";
  };

  npmDepsHash = "sha256-zMzQEM5mV14gewzYhy1F2bNEugXjZSOviYwYVV2Cb8c=";

  postPatch = ''
    ln -s ${bw_web_builds}/{patches,resources} ..
    PATH="${git}/bin:$PATH" VAULT_VERSION="${lib.removePrefix "web-" src.rev}" \
      bash ${bw_web_builds}/scripts/apply_patches.sh
  '';

  nativeBuildInputs = [
    # signalr through gyp wants to import distutils
    python311
  ];

  makeCacheWritable = true;

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmBuildScript = "dist:oss:selfhost";

  npmBuildFlags = [
    "--workspace" "apps/web"
  ];

  npmFlags = [ "--legacy-peer-deps" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/vaultwarden
    mv apps/web/build $out/share/vaultwarden/vault
    runHook postInstall
  '';

  passthru = {
    inherit bw_web_builds;
    tests = nixosTests.vaultwarden;
  };

  meta = with lib; {
    description = "Integrates the web vault into vaultwarden";
    homepage = "https://github.com/dani-garcia/bw_web_builds";
    changelog = "https://github.com/dani-garcia/bw_web_builds/releases/tag/v${version}";
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    inherit (vaultwarden.meta) maintainers;
  };
}
