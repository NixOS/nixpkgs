{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "siobrultech-protocols";
  version = "0.14.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sdwilsh";
    repo = "siobrultech-protocols";
    rev = "refs/tags/v${version}";
    hash = "sha256-8tls2wlLA3wQ78gK4JvvhSWZS5oHRzzsKE73M4i1eyg=";
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

  meta = with lib; {
    description = "A Sans-I/O Python client library for Brultech Devices";
    homepage = "https://github.com/sdwilsh/siobrultech-protocols";
    changelog = "https://github.com/sdwilsh/siobrultech-protocols/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
