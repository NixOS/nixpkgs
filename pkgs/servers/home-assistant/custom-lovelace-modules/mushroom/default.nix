{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "mushroom";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "piitaya";
    repo = "lovelace-mushroom";
    rev = "v${version}";
    hash = "sha256-d38FyJ3pQ6L0AY2j6aTB8CRxJt8LDgT1A9ZpMoQgbXo=";
  };

  npmDepsHash = "sha256-9i7pJh1dmhKobGFcLvZlc0JfaygwVuBvm6ttphl7SWg=";

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
