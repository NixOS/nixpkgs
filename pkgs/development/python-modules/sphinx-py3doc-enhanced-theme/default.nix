{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pypaInstallHook,
  setuptoolsBuildHook,
}:

buildPythonPackage rec {
  pname = "sphinx-py3doc-enhanced-theme";
  version = "2.4.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "ionelmc";
    repo = "sphinx-py3doc-enhanced-theme";
    rev = "refs/tags/v${version}";
    hash = "sha256-D8BfNOxW6x3BeaSDmZyF7SjF0bGvjLUAz2ntK3tMOY0=";
  };

  nativeBuildInputs = [
    pypaInstallHook
    setuptoolsBuildHook
  ];

  pythonImportsCheck = [ "sphinx_py3doc_enhanced_theme" ];

  meta = {
    description = "Theme based on the theme of https://docs.python.org/3/ with some responsive enhancements";
    homepage = "https://github.com/ionelmc/sphinx-py3doc-enhanced-theme/";
    changelog = "https://github.com/ionelmc/sphinx-py3doc-enhanced-theme/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
