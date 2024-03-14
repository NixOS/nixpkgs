{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch2
, setuptools
, aiohttp
, incremental
, systembridgemodels
, pytest-aiohttp
, pytest-socket
, pytestCheckHook
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

  patches = [
    (fetchpatch2 {
      url = "https://github.com/timmo001/system-bridge-connector/commit/a9030cf175ab4b51d77010de89e83cbb426448c2.patch";
      hash = "sha256-0N8knoaEvymSvC92BxDKR0j52oasvOzWosFtHMI2Qmc=";
    })
    (fetchpatch2 {
      url = "https://github.com/timmo001/system-bridge-connector/commit/25aa172775ee983dc4a29b8dda880aefbad70040.patch";
      hash = "sha256-PedW1S1gZmWkS4sJBqSAx3aoA1KppYS5Xlhoaxqkcd4=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    incremental
    systembridgemodels
  ];

  pythonImportsCheck = [ "systembridgeconnector" ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-socket
    pytestCheckHook
  ];

  disabledTests = [
    # ConnectionClosedException: Connection closed to server
    "test_get_files"
  ];

  meta = {
    changelog = "https://github.com/timmo001/system-bridge-connector/releases/tag/${version}";
    description = "This is the connector package for the System Bridge project";
    homepage = "https://github.com/timmo001/system-bridge-connector";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
