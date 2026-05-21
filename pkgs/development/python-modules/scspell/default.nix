{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage {
  pname = "scspell";
  version = "2.3.0-unstable-2025-04-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "myint";
    repo = "scspell";
    rev = "df550351f255c572c1a74852d233c83bbfbd49fb"; # Switch back to tag and remove preVersionCheck next release
    hash = "sha256-mqU7Z6MluHTVYJ8fFbnN0OMWKjQFglD34YRnmJSE/jQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  preVersionCheck = "export version=2.3";

  pythonImportsCheck = [ "scspell" ];

  meta = {
    description = "Spell checker for source code";
    homepage = "https://github.com/myint/scspell";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ guelakais ];
    mainProgram = "scspell";
  };
}
