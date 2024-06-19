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
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "davidbrochart";
    repo = "sqlite-anyio";
    rev = "refs/tags/v${version}";
    hash = "sha256-6khHta7Rzp3g8G/xZnsNZuURFB35JyHz04NTzNJIiBw=";
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
    license = licenses.mit;
  };
}
