{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  elementpath,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "yangson";
  version = "1.6.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CZ-NIC";
    repo = "yangson";
    tag = version;
    hash = "sha256-Hmp+liYSSw4rFScHYyLHDJo1kMOdwXP+jLRkpQFAUno=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    elementpath
    pyyaml
  ];

  pythonRelaxDeps = [ "elementpath" ];

  # only used for docs build
  pythonRemoveDeps = [ "sphinxcontrib-shtest" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yangson" ];

  meta = {
    description = "Library for working with data modelled in YANG";
    mainProgram = "yangson";
    homepage = "https://github.com/CZ-NIC/yangson";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    maintainers = [ ];
  };
}
