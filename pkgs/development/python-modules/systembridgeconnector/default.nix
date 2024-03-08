{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, aiohttp
, incremental
, systembridgemodels
}:

buildPythonPackage rec {
  pname = "systembridgeconnector";
  version = "4.0.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-connector";
    rev = "refs/tags/${version}";
    hash = "sha256-AjdWDEotz5AUo+auxBqXu7EMv/Kt97DZ6vOrFunZ2Fw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    incremental
    systembridgemodels
  ];

  pythonImportsCheck = [ "systembridgeconnector" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/timmo001/system-bridge-connector/releases/tag/${version}";
    description = "This is the connector package for the System Bridge project";
    homepage = "https://github.com/timmo001/system-bridge-connector";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
