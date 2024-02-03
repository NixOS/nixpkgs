{ lib
, fetchFromGitHub
, stdenv
, buildNpmPackage
, nix-update-script
}:

buildNpmPackage rec {
  pname = "jellyfin-web";
  version = "10.8.11";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-web";
    rev = "v${version}";
    hash = "sha256-Gl8eaC/AXBD956tAepwWVG3lSvL4rBCcgmkHeT/mrzM=";
  };

  npmDepsHash = "sha256-HoRteA6KFCFxDdwGtDKrvwWCMYNfYQWlit52RAN1eAU=";

  npmBuildScript = [ "build:production" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a dist $out/share/jellyfin-web

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "Web Client for Jellyfin";
    homepage = "https://jellyfin.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nyanloutre minijackson purcell jojosch ];
  };
}
