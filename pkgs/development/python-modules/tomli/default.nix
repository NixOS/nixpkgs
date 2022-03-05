{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, flit-core

# important downstream dependencies
, flit
, black
, mypy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "tomli";
  version = "1.2.2";
  format = "pyproject";

  outputs = [
    "out"
    "testsout"
  ];

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = pname;
    rev = version;
    sha256 = "sha256-oDjpNzWxTaCC1+WyBKrkR6kp90ZomcZQfyW+xKddDoM=";
  };

  patches = [
    # required for mypy
    ./fix-backwards-compatibility-load.patch
  ];

  nativeBuildInputs = [ flit-core ];

  postInstall = ''
    mkdir $testsout
    cp -R benchmark/ pyproject.toml tests/ $testsout/
  '';

  pythonImportsCheck = [ "tomli" ];

  # check in passthru.tests.pytest to escape infinite recursion with setuptools-scm
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
    inherit flit black mypy setuptools-scm;
  };

  meta = with lib; {
    description = "A Python library for parsing TOML, fully compatible with TOML v1.0.0";
    homepage = "https://github.com/hukkin/tomli";
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch SuperSandro2000 ];
  };
}
