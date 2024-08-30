{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "weather-chart-card";
  version = "2.4.9";

  src = fetchFromGitHub {
    owner = "mlamberts78";
    repo = "weather-chart-card";
    rev = "V${version}";
    hash = "sha256-1mM5zxBwYUqdoXQyyCJgaih+RlPL+VBWNNbFnErGSco=";
  };

  npmDepsHash = lib.fakeHash;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/weather-chart-card.js $out/
    cp -r dist/icons $out/
    cp -r dist/icons2 $out/

    runHook postInstall
  '';

  passthru.entrypoint = "weather-chart-card.js";

  meta = with lib; {
    description = "Custom weather card with charts";
    homepage = "https://github.com/mlamberts78/weather-chart-card";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.all;
  };
}
