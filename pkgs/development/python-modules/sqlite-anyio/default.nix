{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  anyio,
  pytestCheckHook,
  trio,
}:

buildPythonPackage rec {
  pname = "sqlite-anyio";
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "davidbrochart";
    repo = "sqlite-anyio";
    rev = "refs/tags/v${version}";
    hash = "sha256-cZyTpFmYD0l20Cmxl+Hwfh3oVkWvtXD45dMpcSwA2QE=";
  };

  build-system = [ hatchling ];

  dependencies = [ anyio ];

  pythonImportsCheck = [ "sqlite_anyio" ];

  nativeCheckInputs = [
    pytestCheckHook
    trio
  ];

  meta = with lib; {
    description = "Asynchronous client for SQLite using AnyIO";
    homepage = "https://github.com/davidbrochart/sqlite-anyio";
    changelog = "https://github.com/davidbrochart/sqlite-anyio/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
