{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
}:

buildNpmPackage rec {
  pname = "weather-chart-card";
  version = "2.4.11";

  src = fetchFromGitHub {
    owner = "mlamberts78";
    repo = "weather-chart-card";
    rev = "V${version}";
    hash = "sha256-JF7+XataMdUIGXfonF4XlZGitY9kqKony/U0/yw5jUA=";
  };

  postPatch = ''
    rm -rf dist
    ln -s ${./package-lock.json} ./package-lock.json
  '';

  npmDeps = fetchNpmDeps {
    inherit src postPatch;
    hash = "sha256-OJF8N7vPLRX0ec5gaQKAxLR227uoeuAU5z+QVNyOeTY=";
  };

  installPhase = ''
    mkdir $out
    cp -R dist/* $out/
  '';

  meta = {
    description = "Custom weather card with charts";
    homepage = "https://github.com/mlamberts78/weather-chart-card";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.all;
  };
}
