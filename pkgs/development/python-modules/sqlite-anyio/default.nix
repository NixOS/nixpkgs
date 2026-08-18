{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  anyio,
  pytestCheckHook,
  trio,
}:

buildPythonPackage rec {
  pname = "sqlite-anyio";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "davidbrochart";
    repo = "sqlite-anyio";
    tag = "v${version}";
    hash = "sha256-1riZiLBccg7Vqq+a8xT5Lr4vxjkeMbf1wqXnTTgY8iY=";
  };

  build-system = [ hatchling ];

  dependencies = [ anyio ];

  pythonImportsCheck = [ "sqlite_anyio" ];

  nativeCheckInputs = [
    pytestCheckHook
    trio
  ];

  meta = {
    description = "Asynchronous client for SQLite using AnyIO";
    homepage = "https://github.com/davidbrochart/sqlite-anyio";
    changelog = "https://github.com/davidbrochart/sqlite-anyio/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
