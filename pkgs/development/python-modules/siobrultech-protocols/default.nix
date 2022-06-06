{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pyyaml
}:

buildPythonPackage rec {
  pname = "siobrultech-protocols";
  version = "0.6.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sdwilsh";
    repo = "siobrultech-protocols";
    rev = "v${version}";
    hash = "sha256-d4zAwcSCyC78dJZtxFkpdYurxDRon2cRgzInllP2qJQ=";
  };

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [
    "siobrultech_protocols.gem.api"
    "siobrultech_protocols.gem.protocol"
  ];

  meta = {
    description = "A Sans-I/O Python client library for Brultech Devices";
    homepage = "https://github.com/sdwilsh/siobrultech-protocols";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
