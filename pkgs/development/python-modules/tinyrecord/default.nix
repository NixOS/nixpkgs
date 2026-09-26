{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  tinydb,
}:

buildPythonPackage (finalAttrs: {
  pname = "tinyrecord";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eugene-eeo";
    repo = "tinyrecord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mF4hpHuNyiQ5DurRnyLck5e/Vp26GCLkhD8eeSB4NYs=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    tinydb
  ];

  enabledTestPaths = [ "tests.py" ];

  pythonImportsCheck = [ "tinyrecord" ];

  meta = {
    description = "Transaction support for TinyDB";
    homepage = "https://github.com/eugene-eeo/tinyrecord";
    changelog = "https://github.com/eugene-eeo/tinyrecord/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
