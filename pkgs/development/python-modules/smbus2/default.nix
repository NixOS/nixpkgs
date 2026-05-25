{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "smbus2";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kplindegaard";
    repo = "smbus2";
    tag = finalAttrs.version;
    hash = "sha256-CWcRlbZTLiB45DaV6rbhvlk8cTaEJgPAq/JDmbxD7H4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "smbus2" ];

  meta = {
    description = "Drop-in replacement for smbus-cffi/smbus-python";
    homepage = "https://smbus2.readthedocs.io/";
    changelog = "https://github.com/kplindegaard/smbus2/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
