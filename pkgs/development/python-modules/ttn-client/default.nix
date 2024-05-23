{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ttn-client";
  version = "0.0.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "angelnu";
    repo = "thethingsnetwork_python_client";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZLSMxFyzfPtz51fsY2wgucHzcAnSrL7VPOuW7DXTNbQ=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ttn_client" ];

  meta = with lib; {
    description = "Module to fetch/receive and parse uplink messages from The Thinks Network";
    homepage = "https://github.com/angelnu/thethingsnetwork_python_client";
    changelog = "https://github.com/angelnu/thethingsnetwork_python_client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
