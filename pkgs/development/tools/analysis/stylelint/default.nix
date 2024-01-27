{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "stylelint";
  version = "16.1.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-r6FSPMOvx0SI8u2qqk/ALmlSMCcCb3JlAHEawdGoERw=";
  };

  npmDepsHash = "sha256-SHZ7nB4//8IAc8ApmmHbeWi954Za6Ryv+bYuHnZ3Ef0=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    homepage = "https://stylelint.io";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
