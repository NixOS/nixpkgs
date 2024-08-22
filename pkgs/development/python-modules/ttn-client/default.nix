{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ttn-client";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "angelnu";
    repo = "thethingsnetwork_python_client";
    rev = "refs/tags/v${version}";
    hash = "sha256-CAodXoc2T/vyAQKWYCm3te3urbSpGMZ7gmYlvDmTEQY=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ttn_client" ];

  disabledTests = [
    # Test require network access
    "test_connection_auth_error"
  ];

  meta = with lib; {
    description = "Module to fetch/receive and parse uplink messages from The Thinks Network";
    homepage = "https://github.com/angelnu/thethingsnetwork_python_client";
    changelog = "https://github.com/angelnu/thethingsnetwork_python_client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
