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
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RhetTbull";
    repo = "strpdatetime";
    tag = "v${version}";
    hash = "sha256-a+KUM9gQAcNg3ju+YyQXafDlADYCV6B+Wy7EBtcO3S4=";
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
