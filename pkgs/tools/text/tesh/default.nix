{ python3Packages, fetchFromGitHub }:

let
  version = "0.3.2";
in python3Packages.buildPythonPackage rec {
  pname = "tesh";
  inherit version;

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OceanSprint";
    repo = "tesh";
    rev = version;
    hash = "sha256-GIwg7Cv7tkLu81dmKT65c34eeVnRR5MIYfNwTE7j2Vs=";
  };

  checkInputs = [ python3Packages.pytest ];
  nativeBuildInputs = [ python3Packages.poetry-core ];
  propagatedBuildInputs = with python3Packages; [ click pexpect ];
}
