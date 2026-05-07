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
  version = "1.7.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CZ-NIC";
    repo = "yangson";
    tag = version;
    hash = "sha256-hod18DLfITuPB1n/FkxvQozguP9tCIDNLlV2V5MtmBU=";
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
