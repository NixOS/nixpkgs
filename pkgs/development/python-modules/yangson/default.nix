{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  elementpath,
  pyyaml,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "yangson";
  version = "1.5.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CZ-NIC";
    repo = "yangson";
    rev = "refs/tags/${version}";
    hash = "sha256-/9MxCkcPGRNZkuwAAvlr7gtGcyxXtliski7bNtFhVBE=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "setuptools"
  ];

  dependencies = [
    elementpath
    pyyaml
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yangson" ];

  meta = with lib; {
    description = "Library for working with data modelled in YANG";
    mainProgram = "yangson";
    homepage = "https://github.com/CZ-NIC/yangson";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    maintainers = [ ];
  };
}
