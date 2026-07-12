{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "uri-template";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plinss";
    repo = "uri_template";
    tag = "v${version}";
    hash = "sha256-38HFFqM6yfpsPrhIpE639ePy/NbLqKw7gbnE3y8sL3w=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  pythonImportsCheck = [ "uri_template" ];

  meta = {
    description = "Implementation of RFC 6570 URI Templates";
    homepage = "https://github.com/plinss/uri_template/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
