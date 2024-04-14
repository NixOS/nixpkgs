{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "stylelint";
  version = "16.3.1";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-o4gi7pJ4ewdHANfa1Pgj4fxx9+bhQv6ciVWyuFn1OTs=";
  };

  npmDepsHash = "sha256-vgkrhOFQ0A0hp00bD1z3yt9s+UDHDTocNJuwZR9hOOA=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
