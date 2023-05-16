{ lib
, aiohttp
, awesomeversion
, buildPythonPackage
, fetchPypi
, hatchling
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tplink-omada-client";
<<<<<<< HEAD
  version = "1.3.3";
=======
  version = "1.2.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "tplink_omada_client";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-Jo0p/28Hzokeq0SAdyWfkKzoscVkQj9kP3VnRlWjR8o=";
=======
    hash = "sha256-I9lD99IxEq97ANJx0Aeh7YXdPU6izEjWgjJHCaiAWRI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    aiohttp
    awesomeversion
  ];

  # Module have no tests
  doCheck = false;

  pythonImportsCheck = [
    "tplink_omada_client"
  ];

  meta = with lib; {
    description = "Library for the TP-Link Omada SDN Controller API";
    homepage = "https://github.com/MarkGodwin/tplink-omada-api";
    changelog = "https://github.com/MarkGodwin/tplink-omada-api/releases/tag/release%2Fv${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
