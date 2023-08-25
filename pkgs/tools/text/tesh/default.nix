{ python3Packages, fetchFromGitHub }:

let
  version = "0.3.0";
in python3Packages.buildPythonPackage rec {
  pname = "tesh";
  inherit version;

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OceanSprint";
    repo = "tesh";
    rev = version;
    sha256 = "sha256-/CSYz2YXbjKZszb1HMOCS+srVJ+TcFSeLeuz9VvtlI4=";
  };

  prePatch = ''
      substituteInPlace pyproject.toml \
      --replace "poetry.masonry" "poetry.core.masonry"
  '';

  checkInputs = [ python3Packages.pytest ];
  nativeBuildInputs = [ python3Packages.poetry-core ];
  propagatedBuildInputs = with python3Packages; [ click pexpect ];
}
