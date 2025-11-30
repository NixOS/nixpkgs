{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tinytag";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tinytag";
    repo = "tinytag";
    tag = version;
    hash = "sha256-DyjFIaC7FwU5pvRfQgpBCc76dps287rcQ7mxggOZjdw=";
  };

  build-system = [
    setuptools
    flit-core
  ];

  pythonImportsCheck = [ "tinytag" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Read audio file metadata";
    homepage = "https://github.com/tinytag/tinytag";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
