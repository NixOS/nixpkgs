{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  setuptools,
  argostranslate,
  beautifulsoup4,
}:

buildPythonPackage (finalAttrs: {
  pname = "translatehtml";
  version = "1.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "argosopentech";
    repo = "translate-html";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A94N/nfYSVwi0M3SpNFqlXrRNOCpIi9agOCAlH66QcI=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "beautifulsoup4" ];

  dependencies = [
    argostranslate
    beautifulsoup4
  ];

  pythonImportsCheck = [ "translatehtml" ];
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  meta = {
    description = "Translate HTML using Beautiful Soup and Argos Translate";
    homepage = "https://www.argosopentech.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ misuzu ];
  };
})
