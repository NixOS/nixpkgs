{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyxdg,
  setuptools,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "scspell";
  version = "2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "myint";
    repo = "scspell";
    tag = "v${version}";
    hash = "sha256-XiUdz+uHOJlqo+TWd1V/PvzkGJ2kPXzJJSe5Smfdgec=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyxdg
  ];

  nativeCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  versionCheckProgramArg = "--version";

  pythonImportsCheck = [ "scspell" ];

  meta = {
    description = "Spell checker for source code";
    homepage = "https://github.com/myint/scspell";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ guelakais ];
    mainProgram = "scspell";
  };
}
