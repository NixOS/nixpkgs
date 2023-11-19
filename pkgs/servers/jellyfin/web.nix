{ lib
, fetchFromGitHub
, stdenv
, buildNpmPackage
, nix-update-script
}:

buildNpmPackage rec {
  pname = "jellyfin-web";
  version = "10.8.12";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-web";
    rev = "v${version}";
    hash = "sha256-T5MACoNg6yADfM7eike3f6V/ELZXrZYP+3Cz6ea8WtQ=";
  };

  npmDepsHash = "sha256-s+14x/jucCAxDWlQjCngjGtLB+4PCuO6R0qxP+SZ1+s=";

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
