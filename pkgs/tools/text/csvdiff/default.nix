{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "csvdiff";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "aswinkarthik";
    repo = "csvdiff";
    rev = "v${version}";
    hash = "sha256-66R5XxrNQ1YMMQicw0VCF/XzRo//5Gqdjlher/uMoTE=";
  };

  vendorHash = "sha256-rhOjBMCyfirEI/apL3ObHfKZeuNPGSt84R9lwCbRIpg=";

  meta = with lib; {
    homepage = "https://aswinkarthik.github.io/csvdiff/";
    description = "Fast diff tool for comparing csv files";
    mainProgram = "csvdiff";
    license = licenses.mit;
    maintainers = with maintainers; [ turion ];
  };
}
