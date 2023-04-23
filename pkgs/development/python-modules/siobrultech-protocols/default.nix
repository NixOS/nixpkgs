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
  version = "0.9.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sdwilsh";
    repo = "siobrultech-protocols";
    rev = "refs/tags/v${version}";
    hash = "sha256-8qhg7PX4u4vN2+hWXzFjC1ZzgCEhkSr9Fn58Lc4E76c=";
  };

  nativeCheckInputs = [
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
