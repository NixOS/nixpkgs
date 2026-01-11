{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
  pytest-freezer,
  pytest-httpserver,
  pytest-randomly,
  pytest-timeout,
  pytestCheckHook,
  uv-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "urlscan-python";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "urlscan";
    repo = "urlscan-python";
    tag = "v${version}";
    hash = "sha256-HkovBmmVvUYA5U43w5TUOcwhZAN/0o0BETd1s9R940w=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    pytest-freezer
    pytest-httpserver
    pytest-randomly
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "urlscan" ];

  meta = {
    description = "Python API client for urlscan.io";
    homepage = "https://github.com/urlscan/urlscan-python/";
    changelog = "https://github.com/urlscan/urlscan-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
