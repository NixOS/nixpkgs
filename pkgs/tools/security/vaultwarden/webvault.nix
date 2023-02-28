{ lib
, buildNpmPackage
, fetchFromGitHub
, git
, nixosTests
, nodejs-16_x
, python3
}:

let
  buildNpmPackage' = buildNpmPackage.override { nodejs = nodejs-16_x; };

  version = "2022.12.0";

  bw_web_builds = fetchFromGitHub {
    owner = "dani-garcia";
    repo = "bw_web_builds";
    rev = "v${version}";
    hash = "sha256-4yUE0ySUCKmmbca+T8qjqSO0AHZEUAHZ4nheRjpDnZo=";
  };
in buildNpmPackage' {
  pname = "vaultwarden-webvault";
  inherit version;

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "web-v${version}";
    hash = "sha256-CsbnnP12P7JuGDOm5Ia73SzET/jCx3qRbz9vdUf7lCA=";
  };

  npmDepsHash = "sha256-wWOtVGNOzY2s82nfQDuWgA4ukpJxJr8Z7Y+rFPq2QdU=";

  postPatch = ''
    ln -s ${bw_web_builds}/{patches,resources} ..
    PATH="${git}/bin:$PATH" VAULT_VERSION=${bw_web_builds.rev} \
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
