{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  python-dateutil,
  requests,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "srpenergy";
  version = "1.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lamoreauxlab";
    repo = "srpenergy-api-client-python";
    tag = finalAttrs.version;
    hash = "sha256-V0WDY1tWt5O/35wDDE0e89bqspcKMtl9/QK2A7NIZu8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==" "setuptools>="
  '';

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # requires an account
    "quickstart_test.py"
  ];

  pythonImportsCheck = [ "srpenergy.client" ];

  meta = {
    changelog = "https://github.com/lamoreauxlab/srpenergy-api-client-python/releases/tag/${finalAttrs.version}";
    description = "Unofficial Python module for interacting with Srp Energy data";
    homepage = "https://github.com/lamoreauxlab/srpenergy-api-client-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
