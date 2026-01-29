{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage {
  pname = "scspell";
  version = "2.3-unstable-2025-04-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "myint";
    repo = "scspell";
    rev = "df550351f255c572c1a74852d233c83bbfbd49fb";
    hash = "sha256-mqU7Z6MluHTVYJ8fFbnN0OMWKjQFglD34YRnmJSE/jQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  preVersionCheck = "version=2.3"; # While we're on an unstable rev

  pythonImportsCheck = [ "scspell" ];

  meta = {
    description = "Spell checker for source code";
    homepage = "https://github.com/myint/scspell";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ guelakais ];
    mainProgram = "scspell";
  };
}
