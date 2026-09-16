{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  cachetools,
  httpx,
  pydantic,
  pydantic-core,
  pyjwt,
  sniffio,
  typing-extensions,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "zai-sdk";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zai-org";
    repo = "z-ai-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wGPN4yfmqVuy8Cy30nvA0/WDhUZW6BiYCp3etTFjeoE=";
  };

  postPatch = ''
    # Remove poetry-plugin-pypi-mirror from build-system (not available in nixpkgs)
    substituteInPlace pyproject.toml --replace-fail \
    'requires = ["poetry-core>=1.0.0", "poetry-plugin-pypi-mirror==0.4.2"]' \
    'requires = ["poetry-core>=1.0.0"]'
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    cachetools
    httpx
    pydantic
    pydantic-core
    pyjwt
    sniffio
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-asyncio
    syrupy
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Integration tests require API keys and network access
    "tests/integration_tests"
    # test_client.py creates ZaiClient() without API key
    "tests/unit_tests/test_client.py"
  ];

  pythonImportsCheck = [
    "zai"
  ];

  meta = {
    description = "Z.AI's official Python SDK";
    homepage = "https://github.com/zai-org/z-ai-sdk-python";
    changelog = "https://github.com/zai-org/z-ai-sdk-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
})
