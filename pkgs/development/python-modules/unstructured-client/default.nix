{
  aiofiles,
  buildPythonPackage,
  certifi,
  deepdiff,
  fetchFromGitHub,
  httpcore,
  httpx,
  lib,
  pydantic,
  pypdf,
  pypdfium2,
  pytest-asyncio,
  pytestCheckHook,
  python,
  requests-toolbelt,
  setuptools,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "unstructured-client";
  version = "0.47.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Unstructured-IO";
    repo = "unstructured-python-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9bjv3NJEVgMWAnlK3FQHqaT1nBRXjw3qpb90R93nSBE=";
  };

  preBuild = ''
    ${python.interpreter} scripts/prepare_readme.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    certifi
    httpcore
    httpx
    pydantic
    pypdf
    pypdfium2
    requests-toolbelt
  ];

  pythonImportsCheck = [ "unstructured_client" ];

  nativeCheckInputs = [
    deepdiff
    pytest-asyncio
    pytestCheckHook
  ];

  # see test-unit in Makefile
  enabledTestPaths = [
    "_test_unstructured_client"
  ];

  enabledTests = [
    "unit"
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert DeclaredError...audience=None) == DeclaredError...audience=None)
    "test_parse_declared_error_fields"

    #  assert len(attempts) == (1 if stop else 2)
    #  AssertionError: assert 1 == 2
    #   +  where 1 = len([<Request('GET', 'http://test.invalid')>])
    "test_declared_retry_verdict"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/Unstructured-IO/unstructured-python-client/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Python Client SDK for Unstructured API";
    homepage = "https://github.com/Unstructured-IO/unstructured-python-client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
