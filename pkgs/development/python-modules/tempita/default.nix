{ lib, buildPythonPackage, fetchFromGitHub, nose }:

buildPythonPackage {
  version = "0.5.3-2016-09-28";
  pname = "tempita";

  src = fetchFromGitHub {
    owner = "gjhiggins";
    repo = "tempita";
    rev = "47414a7c6e46a9a9afe78f0bce2ea299fa84d10";
    sha256 = "0f33jjjs5rvp7ar2j6ggyfykcrsrn04jaqcq71qfvycf6b7nw3rn";
  };

  buildInputs = [ nose ];

  meta = {
    homepage = https://github.com/gjhiggins/tempita;
    description = "A very small text templating language";
    license = lib.licenses.mit;
  };
}
