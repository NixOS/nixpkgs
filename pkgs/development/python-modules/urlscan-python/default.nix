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
  python-dotenv,
  uv-dynamic-versioning,
}:

buildPythonPackage (finalAttrs: {
  pname = "urlscan-python";
  version = "2026.08.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "urlscan";
    repo = "urlscan-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N7l4+Izn0fhRuoOejtR4/WHTxfoaQVWM6EdSIB0wm+0=";
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
    python-dotenv
  ];

  pythonImportsCheck = [ "urlscan" ];

  disabledTestPaths = [
    # Tests require an API key
    "tests/integration"
  ];

  meta = {
    description = "Python API client for urlscan.io";
    homepage = "https://github.com/urlscan/urlscan-python/";
    changelog = "https://github.com/urlscan/urlscan-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
