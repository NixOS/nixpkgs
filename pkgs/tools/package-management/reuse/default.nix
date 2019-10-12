{ lib, python3Packages, fetchFromGitHub }:

with python3Packages;

buildPythonApplication rec {
  pname = "reuse";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "fsfe";
    repo = "reuse-tool";
    rev = "v${version}";
    sha256 = "0gwipwikhxsk0p8wvdl90xm7chfi2jywb1namzznyymifl1vsbgh";
  };

  propagatedBuildInputs = [ debian license-expression requests ];

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "A tool for compliance with the REUSE Initiative recommendations";
    license = with licenses; [ asl20 cc-by-sa-40 cc0 gpl3 ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
