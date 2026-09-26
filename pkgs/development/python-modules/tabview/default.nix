{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "tabview";
  version = "1.4.4";
  pyproject = true;

  # newest release only available as wheel on pypi
  src = fetchFromGitHub {
    owner = "TabViewer";
    repo = "tabview";
    tag = finalAttrs.version;
    hash = "sha256-lVhGenSw4ugfZYEqV2CCNEH5qqx0T8XP+4IP26BDNLQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Python curses command line CSV and tabular data viewer";
    mainProgram = "tabview";
    homepage = "https://github.com/TabViewer/tabview";
    changelog = "https://github.com/TabViewer/tabview/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
