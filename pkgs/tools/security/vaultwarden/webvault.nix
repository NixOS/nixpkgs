{ lib
, buildNpmPackage
, fetchFromGitHub
, git
, nixosTests
, python3
, vaultwarden
}:

let
  version = "2024.3.1";

  bw_web_builds = fetchFromGitHub {
    owner = "dani-garcia";
    repo = "bw_web_builds";
    rev = "v${version}";
    hash = "sha256-oi0H8TIQwtpzxKoQGnKaOY0bcWu7avTtrY+NgNRiq8k=";
  };

in buildNpmPackage rec {
  pname = "vaultwarden-webvault";
  inherit version;

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "web-v${lib.removeSuffix "b" version}";
    hash = "sha256-JBEP4dNGL4rYKl2qNyhB2y/wZunikaGFltGVXLxgMWI=";
  };

  npmDepsHash = "sha256-vNudSHIMmF7oXGz+ZymQahyHebs/CBDc6Oy1g0A5nqA=";

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
