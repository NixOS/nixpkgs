{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  beautifulsoup4,
  requests,
  rsa,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "steampy";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bukson";
    repo = "steampy";
    tag = finalAttrs.version;
    hash = "sha256-dGcqJGRQ88vXy+x2U+ykutP4RnzTUqJlmhXmcr+4maE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    requests
    rsa
  ];

  pythonImportsCheck = [ "steampy" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Require Steam credentials
    "test/test_client.py"
    "test/test_guard.py"
    "test/test_market.py"
  ];

  meta = {
    description = "Steam trading library";
    homepage = "https://github.com/bukson/steampy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artur-sannikov ];
  };
})
