{ lib
, fetchFromGitHub
, stdenv
, buildNpmPackage
, nix-update-script
}:

buildNpmPackage rec {
  pname = "jellyfin-web";
  version = "10.8.13";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-web";
    rev = "v${version}";
    hash = "sha256-2W9s8TQV9BtxNYIrCbGRh5EUw0brwxSHohnb7269pQE=";
  };

  npmDepsHash = "sha256-i077UAxY2K12VXkHYbGYZRV1uhgdGUnoDbokSk2ZDIA=";

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
