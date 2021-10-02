{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, flit-core
}:

buildPythonPackage rec {
  pname = "tomli";
  version = "1.1.0";
  format = "pyproject";

  outputs = [
    "out"
    "testsout"
  ];

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = pname;
    rev = version;
    sha256 = "1cj6iil9sii1zl0l4pw7h4alcnhwdbxinpph2f0rm5rghrp6prjm";
  };

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
  };

  meta = with lib; {
    description = "A Python library for parsing TOML, fully compatible with TOML v1.0.0";
    homepage = "https://github.com/hukkin/tomli";
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch SuperSandro2000 ];
  };
}
