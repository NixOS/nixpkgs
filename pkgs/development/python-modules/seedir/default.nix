{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  natsort,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "seedir";
  version = "0.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "earnestt1234";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ioez5lBNyiBK3poL2Px3KtCQeM+Gh2d4iD3SoAIHFAk=";
  };

  propagatedBuildInputs = [ natsort ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "seedir" ];

  pytestFlagsArray = [ "tests/tests.py" ];

  meta = with lib; {
    description = "Module for for creating, editing, and reading folder tree diagrams";
    mainProgram = "seedir";
    homepage = "https://github.com/earnestt1234/seedir";
    changelog = "https://github.com/earnestt1234/seedir/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
