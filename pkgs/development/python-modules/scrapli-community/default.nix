{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  scrapli,
}:

buildPythonPackage (finalAttrs: {
  pname = "scrapli-community";
  version = "2025.01.30";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scrapli";
    repo = "scrapli_community";
    tag = finalAttrs.version;
    hash = "sha256-RvwMHLXk+sJs6G7qbBoesNNCJmi1y8HsEGp6Fdl/RAY=";
  };

  build-system = [ setuptools ];

  dependencies = [ scrapli ];

  pythonRemoveDeps = [ "scrapli" ];

  pythonImportCheck = [ "scrapli_community" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # TODO investigate: ModuleNotFoundError: No module named 'scrapli.driver'
  doCheck = false;

  meta = {
    description = "Scrapli community platforms";
    homepage = "https://scrapli.github.io/scrapli_community/";
    changelog = "https://github.com/scrapli/scrapli_community/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
