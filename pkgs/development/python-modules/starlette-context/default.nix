{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  starlette,
}:

buildPythonPackage (finalAttrs: {
  pname = "starlette-context";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tomwojcik";
    repo = "starlette-context";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cxhTrLLIjlqaR07VVgHmvYctk7+7fDjbGb39PbJbGgk=";
  };

  build-system = [ hatchling ];

  dependencies = [ starlette ];

  nativeCheckInputs = [
    httpx
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "starlette_context" ];

  meta = {
    description = "Middleware for Starlette that allows you to store and access the context data of a request";
    homepage = "https://github.com/tomwojcik/starlette-context";
    changelog = "https://github.com/tomwojcik/starlette-context/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
