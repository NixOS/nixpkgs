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
  version = "0.32.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Unstructured-IO";
    repo = "unstructured-python-client";
    tag = "v${version}";
    hash = "sha256-bHiYV86c3ViCLix6vR55GiM8qTv64jj9tD8nF/jMUm4=";
  };

  preBuild = ''
    ${python.interpreter} scripts/prepare_readme.py
  '';

  build-system = [ poetry-core ];

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

  pytestFlagsArray = [
    # see test-unit in Makefile
    "_test_unstructured_client"
    "-k"
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
