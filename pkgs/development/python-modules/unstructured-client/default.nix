{
  aiofiles,
  buildPythonPackage,
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
}:

buildPythonPackage (finalAttrs: {
  pname = "unstructured-client";
  version = "0.44.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Unstructured-IO";
    repo = "unstructured-python-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-joQj2tMOD3bW/bU0ffZ7Usfh7hRWrVGKfGreC9ks18E=";
  };

  preBuild = ''
    ${python.interpreter} scripts/prepare_readme.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
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

  meta = {
    changelog = "https://github.com/Unstructured-IO/unstructured-python-client/blob/${finalAttrs.src.tag}/RELEASES.md";
    description = "Python Client SDK for Unstructured API";
    homepage = "https://github.com/Unstructured-IO/unstructured-python-client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
