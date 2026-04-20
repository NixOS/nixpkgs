{
  aiofiles,
  buildPythonPackage,
  cryptography,
  deepdiff,
  fetchFromGitHub,
  httpcore,
  httpx,
  lib,
  poetry-core,
  pydantic,
  pypdf,
  pypdfium2,
  pytest-asyncio,
  pytestCheckHook,
  python,
  requests-toolbelt,
}:

buildPythonPackage (finalAttrs: {
  pname = "unstructured-client";
  version = "0.42.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Unstructured-IO";
    repo = "unstructured-python-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xuaGvQEu1QpLn33AUgdWW120pVVNVPL08U/SCA7kGvc=";
  };

  preBuild = ''
    ${python.interpreter} scripts/prepare_readme.py
  '';

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "pydantic"
  ];

  dependencies = [
    aiofiles
    cryptography
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
