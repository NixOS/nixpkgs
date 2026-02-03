{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "udsoncan";
  version = "1.25.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pylessard";
    repo = "python-udsoncan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+0AUGsaIH0uArK5wDaMvL60VHPB5T89afJQh5Qq//mE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "udsoncan" ];

  meta = {
    description = "Implementation of the Unified Diagnostic Services (UDS) protocol defined by ISO-14229";
    homepage = "https://udsoncan.readthedocs.io/en/v${finalAttrs.version}/";
    changelog = "https://github.com/pylessard/python-udsoncan/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RossSmyth ];
  };
})
