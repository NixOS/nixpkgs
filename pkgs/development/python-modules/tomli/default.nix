{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, flit-core
, unittestCheckHook

  # important downstream dependencies
, flit
, black
, mypy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "tomli";
  version = "2.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = pname;
    rev = version;
    sha256 = "sha256-v0ZMrHIIaGeORwD4JiBeLthmnKZODK5odZVL0SY4etA=";
  };

  nativeBuildInputs = [ flit-core ];

  checkInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "tomli" ];

  passthru.tests = {
    # test downstream dependencies
    inherit flit black mypy setuptools-scm;
  };

  meta = with lib; {
    description = "A Python library for parsing TOML, fully compatible with TOML v1.0.0";
    homepage = "https://github.com/hukkin/tomli";
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch SuperSandro2000 ];
  };
}
