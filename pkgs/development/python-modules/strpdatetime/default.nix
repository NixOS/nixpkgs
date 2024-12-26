{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  textx,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "strpdatetime";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RhetTbull";
    repo = "strpdatetime";
    rev = "v${version}";
    hash = "sha256-eb3KJCFRkEt9KEP1gMQYuP50qXqItrexJhKvtJDHl9o=";
  };

  build-system = [ poetry-core ];

  dependencies = [ textx ];
  pythonRelaxDeps = [ "textx" ];

  patches = [ ./fix-locale.patch ];

  pythonImportsCheck = [ "strpdatetime" ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Parse strings into Python datetime objects";
    license = lib.licenses.psfl;
    changelog = "https://github.com/RhetTbull/strpdatetime/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://github.com/RhetTbull/strpdatetime";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
