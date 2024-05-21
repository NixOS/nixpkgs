{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, starlette
}:

buildPythonPackage rec {
  pname = "starlette-context";
  version = "0.3.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tomwojcik";
    repo = "starlette-context";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZKwE2M86clYKdptd0o/j8VYUOj/Y/72uUnpxFbJ65vw=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    starlette
  ];

  nativeCheckInputs = [
    httpx
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "starlette_context"
  ];

  meta = with lib; {
    description = "Middleware for Starlette that allows you to store and access the context data of a request";
    homepage = "https://github.com/tomwojcik/starlette-context";
    changelog = "https://github.com/tomwojcik/starlette-context/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
