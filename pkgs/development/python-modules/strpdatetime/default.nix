{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  textx,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "strpdatetime";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RhetTbull";
    repo = "strpdatetime";
    tag = "v${version}";
    hash = "sha256-p/iLq+x+dRW2QPva/VEA9emtxb0k3hnL91l1itTsYSc=";
  };

  build-system = [ hatchling ];

  dependencies = [ textx ];
  pythonRelaxDeps = [ "textx" ];

  patches = [ ./fix-locale.patch ];

  pythonImportsCheck = [ "strpdatetime" ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Parse strings into Python datetime objects";
    license = lib.licenses.psfl;
    changelog = "https://github.com/RhetTbull/strpdatetime/blob/${src.tag}/CHANGELOG.md";
    homepage = "https://github.com/RhetTbull/strpdatetime";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
