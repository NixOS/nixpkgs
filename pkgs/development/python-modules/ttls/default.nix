{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ttls";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jschlyter";
    repo = "ttls";
    tag = "v${version}";
    hash = "sha256-itGXZbQZ+HYpiwySLeGN3mPy3fgsxx0A9byOxIVpRBc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ttls" ];

  meta = with lib; {
    description = "Module to interact with Twinkly LEDs";
    mainProgram = "ttls";
    homepage = "https://github.com/jschlyter/ttls";
    changelog = "https://github.com/jschlyter/ttls/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
