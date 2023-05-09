{ lib
, buildPythonPackage
, fetchFromGitHub

# bootstrap
, flit-core
, installer
, python

# tests
, unittestCheckHook

 # important downstream dependencies
, black
, flit
, mypy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "tomli";
  version = "2.0.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = "tomli";
    rev = "refs/tags/${version}";
    hash = "sha256-v0ZMrHIIaGeORwD4JiBeLthmnKZODK5odZVL0SY4etA=";
  };

  nativeBuildInputs = [
    flit-core
    installer
  ];

  buildPhase = ''
    runHook preBuild
    ${python.interpreter} -m flit_core.wheel
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${python.interpreter} -m installer --prefix "$out" dist/*.whl
    runHook postInstall
  '';

  pythonImportsCheck = [
    "tomli"
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

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
