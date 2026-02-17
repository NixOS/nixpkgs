{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  httpx,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "telegraph";
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "telegraph";
    owner = "python273";
    tag = "v${version}";
    hash = "sha256-xARX8lSOftNVYY4InR5vU4OiguCJJJZv/W76G9eLgNY=";
  };

  propagatedBuildInputs = [ requests ];

  optional-dependencies = {
    aio = [ httpx ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/" ];

  disabledTests = [ "test_get_page" ];

  pythonImportsCheck = [ "telegraph" ];

  meta = {
    description = "Telegraph API wrapper";
    homepage = "https://github.com/python273/telegraph";
    changelog = "https://github.com/python273/telegraph/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gp2112 ];
  };
}
