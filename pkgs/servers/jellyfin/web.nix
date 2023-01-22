{ lib
, buildNpmPackage
, fetchFromGitHub
, nix-update-script
}:

buildNpmPackage rec {
  pname = "jellyfin-web";
  version = "10.8.8";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-web";
    rev = "v${version}";
    sha256 = "pIoMpNxRtIvs6bhFEoSlFU8aHZ2CBbHnZaA/FVAkGOI=";
  };

  npmDepsHash = "sha256-eVf1Sb5wIWeCbknyBAwmrSyaVy1trTZXB8Uuz3U/8VI=";

  # Don't run the build script twice (https://github.com/jellyfin/jellyfin-web/blob/37dd3fe2b862c7e10a017e89f5d37e3a3df11aad/scripts/prepare.js)
  SKIP_PREPARE = 1;

  npmBuildScript = "build:production";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a dist $out/share/jellyfin-web

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { attrPath = pname; };

  meta = with lib; {
    description = "Web Client for Jellyfin";
    homepage = "https://jellyfin.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nyanloutre minijackson purcell jojosch ];
  };
}
