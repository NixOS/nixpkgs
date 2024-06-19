{
  lib,
  buildPythonPackage,
  fetchPypi,
  paramiko,
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  version = "0.4.0";
  format = "setuptools";
  pname = "sshtunnel";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-58sOp3Tbgb+RhE2yLecqQKro97D5u5ug9mbUdO9r+fw=";
  };

  propagatedBuildInputs = [ paramiko ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  # disable impure tests
  disabledTests = [
    "test_get_keys"
    "connect_via_proxy"
    "read_ssh_config"
  ];

  meta = with lib; {
    description = "Pure python SSH tunnels";
    mainProgram = "sshtunnel";
    homepage = "https://github.com/pahaz/sshtunnel";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
