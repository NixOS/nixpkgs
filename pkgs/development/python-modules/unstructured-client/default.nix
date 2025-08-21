{
  aiofiles,
  buildPythonPackage,
  cryptography,
  deepdiff,
  eval-type-backport,
  fetchFromGitHub,
  httpx,
  lib,
  nest-asyncio,
  poetry-core,
  pydantic,
  pypdf,
  pytest-asyncio,
  pytestCheckHook,
  python,
  python-dateutil,
  requests-toolbelt,
  typing-inspection,
}:

buildPythonPackage rec {
  pname = "unstructured-client";
  version = "0.38.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Unstructured-IO";
    repo = "unstructured-python-client";
    tag = "v${version}";
    hash = "sha256-gzNPzS//7MU6nX3cA0p6dPqIG273VlGMU0ePyObn4d4=";
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
    eval-type-backport
    httpx
    nest-asyncio
    pydantic
    pypdf
    python-dateutil
    requests-toolbelt
    typing-inspection
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
    changelog = "https://github.com/Unstructured-IO/unstructured-python-client/blob/${src.tag}/RELEASES.md";
    description = "Python Client SDK for Unstructured API";
    homepage = "https://github.com/Unstructured-IO/unstructured-python-client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
