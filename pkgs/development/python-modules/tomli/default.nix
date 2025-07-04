{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  unittestCheckHook,

  # important downstream dependencies
  flit,
  black,
  mypy,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "tomli";
  version = "2.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = "tomli";
    rev = version;
    hash = "sha256-4MWp9pPiUZZkjvGXzw8/gDele743NBj8uG4jvK2ohUM=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "tomli" ];

  passthru.tests = {
    # test downstream dependencies
    inherit
      flit
      black
      mypy
      setuptools-scm
      ;
  };

  meta = with lib; {
    description = "Python library for parsing TOML, fully compatible with TOML v1.0.0";
    homepage = "https://github.com/hukkin/tomli";
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch ];
  };
}
