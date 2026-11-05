{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "strenum";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "irgeek";
    repo = "StrEnum";
    tag = "v${version}";
    hash = "sha256-TnCyMDMPEqFiNrLsgmIX47l7RYU8UFo5p/bqJTzjPmI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "strenum" ];

  meta = {
    description = "Module for enum that inherits from str";
    homepage = "https://github.com/irgeek/StrEnum";
    changelog = "https://github.com/irgeek/StrEnum/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
