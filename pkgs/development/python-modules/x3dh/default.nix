{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  xeddsa,
  cryptography,
  pydantic,
  typing-extensions,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
}:
buildPythonPackage rec {
  pname = "x3dh";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syndace";
    repo = "python-x3dh";
    tag = "v${version}";
    hash = "sha256-NLuFfkutFtNrpBcLA/83QArCDrlrT+i85s2d6FHtuT0=";
  };

  strictDeps = true;

  build-system = [
    setuptools
  ];

  dependencies = [
    xeddsa
    cryptography
    pydantic
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "x3dh" ];

  meta = {
    description = "Python Implementation of the Extended Triple Diffie-Hellman key Agreement Protocol";
    homepage = "https://github.com/Syndace/python-x3dh";
    changelog = "https://github.com/Syndace/python-x3dh/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    maintainers = [ ];
  };
}
