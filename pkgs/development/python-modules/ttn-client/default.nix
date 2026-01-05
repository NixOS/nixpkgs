{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ttn-client";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angelnu";
    repo = "thethingsnetwork_python_client";
    tag = "v${version}";
    hash = "sha256-PEkxEKet0nrowWJ4J3AqqqdecO4zSbTampz/Dx0QD2s=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/angelnu/thethingsnetwork_python_client/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
