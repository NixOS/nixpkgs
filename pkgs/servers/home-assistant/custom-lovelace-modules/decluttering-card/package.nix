{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "decluttering-card";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "custom-cards";
    repo = "decluttering-card";
    rev = "v${version}";
    hash = "sha256-8pf7G6RbLdpIdXYz801+wwAc3NcNs8l0x4fSGqlAmG0=";
  };

  npmDepsHash = "sha256-9tmEfKo8n2LR+r40hEqOfn7w6/P29XQ+KZSHL97wUuY=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/decluttering-card.js $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Declutter your lovelace configuration with the help of this card";
    homepage = "https://github.com/custom-cards/decluttering-card";
    changelog = "https://github.com/custom-cards/decluttering-card/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
    platforms = platforms.all;
  };
}
