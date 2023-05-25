{ lib
, fetchFromGitHub
, stdenv
, buildNpmPackage
, nix-update-script
}:

buildNpmPackage rec {
  pname = "jellyfin-web";
  version = "10.8.10";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-web";
    rev = "v${version}";
    hash = "sha256-fJmGiHLwhgd3Ac7ggCbkMu6llob3qN87EpHpCO4K29I=";
  };

  npmDepsHash = "sha256-X8a/pmQGAhoGKhThJ86b50sf0nlsCXGgvLQaxRsmA5Q=";

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
