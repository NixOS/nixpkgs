{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  httpx,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "telegraph";
  version = "2.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    repo = "telegraph";
    owner = "python273";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xARX8lSOftNVYY4InR5vU4OiguCJJJZv/W76G9eLgNY=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  optional-dependencies = {
    aio = [ httpx ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/" ];

  # Needs networking
  disabledTests = [ "test_get_page" ];

  pythonImportsCheck = [ "telegraph" ];

  meta = {
    description = "Telegraph API wrapper";
    homepage = "https://github.com/python273/telegraph";
    changelog = "https://github.com/python273/telegraph/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gp2112 ];
  };
})
