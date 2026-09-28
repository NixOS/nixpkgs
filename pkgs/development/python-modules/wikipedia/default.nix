{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  beautifulsoup4,
  requests,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "wikipedia";
  version = "1.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-2w+tGCn91EGxhSMG6YVjmCBNwHhtKZbdLgyLuOJhM7I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    requests
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "tests/ '*test.py'" ];

  pythonImportsCheck = [ "wikipedia" ];

  meta = {
    description = "Pythonic wrapper for the Wikipedia API";
    homepage = "https://github.com/goldsmith/Wikipedia";
    changelog = "https://github.com/goldsmith/Wikipedia/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
})
