{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "uri-template";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "plinss";
    repo = "uri_template";
    rev = "refs/tags/v${version}";
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

  meta = with lib; {
    description = "An implementation of RFC 6570 URI Templates";
    homepage = "https://github.com/plinss/uri_template/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
