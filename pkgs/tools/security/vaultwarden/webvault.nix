{ lib
, buildNpmPackage
, fetchFromGitHub
, git
, nixosTests
, nodejs_16
, python3
}:

let
  buildNpmPackage' = buildNpmPackage.override { nodejs = nodejs_16; };

  version = "2023.3.0b";

  bw_web_builds = fetchFromGitHub {
    owner = "dani-garcia";
    repo = "bw_web_builds";
    rev = "v${version}";
    hash = "sha256-3kCgT+NsYU7sRJvw56vcPXS7j+eHxgek195zZnamjJw=";
  };
in buildNpmPackage' rec {
  pname = "vaultwarden-webvault";
  inherit version;

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "web-v${lib.removeSuffix "b" version}";
    hash = "sha256-pSaFksfdxVx7vaozR5h+wpPB42qVgs+aXhV7HGFq71E=";
  };

  npmDepsHash = "sha256-ZHbKq7EseYNTWjKi+W66WinmReZbpn3kJB3g0N2z4ww=";

  postPatch = ''
    ln -s ${bw_web_builds}/{patches,resources} ..
    PATH="${git}/bin:$PATH" VAULT_VERSION="${lib.removePrefix "web-" src.rev}" \
      bash ${bw_web_builds}/scripts/apply_patches.sh
  '';

  nativeBuildInputs = [
    python3
  ];

  makeCacheWritable = true;

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmBuildScript = "dist:oss:selfhost";

  npmBuildFlags = [
    "--workspace" "apps/web"
  ];

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
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda msteen mic92 ];
  };
}
