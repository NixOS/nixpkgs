{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "mushroom";
  version = "4.0.7";

  src = fetchFromGitHub {
    owner = "piitaya";
    repo = "lovelace-mushroom";
    rev = "v${version}";
    hash = "sha256-97FW4kNPaoP501xD0W/PjmykwhLbLz7yHVNZiwl/clE=";
  };

  npmDepsHash = "sha256-Gpt17teEbBMHU8teiH66fjZmgq+6v/XovTVxNfHFTg4=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -m0644 dist/mushroom.js $out

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/piitaya/lovelace-mushroom/releases/tag/v${version}";
    description = "Mushroom Cards - Build a beautiful dashboard easily";
    homepage = "https://github.com/piitaya/lovelace-mushroom";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
