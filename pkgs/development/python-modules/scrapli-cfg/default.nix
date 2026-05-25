{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  scrapli,
}:

buildPythonPackage (finalAttrs: {
  pname = "scrapli-cfg";
  version = "2025.01.30";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scrapli";
    repo = "scrapli_cfg";
    tag = finalAttrs.version;
    hash = "sha256-OpS0Yp/INqyDDIPyOxLRTr2XOk3fw428qT2eCrasNVc=";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "scrapli" ];

  dependencies = [ scrapli ];

  pythonImportCheck = [ "scrapli_cfg" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # TODO investigate: ModuleNotFoundError: No module named 'scrapli.driver'
  doCheck = false;

  meta = {
    description = "Scrapli community platforms";
    homepage = "https://scrapli.github.io/scrapli_cfg/";
    changelog = "https://github.com/scrapli/scrapli_cfg/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
