{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  lxml,
  scrapli,
}:

buildPythonPackage (finalAttrs: {
  pname = "scrapli-netconf";
  version = "2026.01.12";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scrapli";
    repo = "scrapli_netconf";
    tag = finalAttrs.version;
    hash = "sha256-ob4CBNF5gIJsSdMRosNA7temkPNVQRT7winFq3ghejo";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "scrapli" ];

  dependencies = [
    scrapli
    lxml
  ];

  pythonImportCheck = [ "scrapli_netconf" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # TODO investigate
  doCheck = false;

  meta = {
    description = "Fast and flexible Python 3.7+ netconf client specifically for network devices";
    homepage = "https://scrapli.github.io/scrapli_netconf/";
    changelog = "https://github.com/scrapli/scrapli_netconf/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
