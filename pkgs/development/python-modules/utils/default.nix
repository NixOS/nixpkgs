{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "utils";
  version = "1.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "haaksmash";
    repo = "pyutils";
    tag = finalAttrs.version;
    hash = "sha256-eb2trh3eawdAcPo3De9NgYN2HT1+FGju/F4V7lga+R4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "utils" ];

  meta = {
    description = "Python set of utility functions and objects";
    homepage = "https://github.com/haaksmash/pyutils";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
