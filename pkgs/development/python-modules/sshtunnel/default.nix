{
  lib,
  buildPythonPackage,
  fetchPypi,
  paramiko,
  pytestCheckHook,
  mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sshtunnel";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-58sOp3Tbgb+RhE2yLecqQKro97D5u5ug9mbUdO9r+fw=";
  };

  # https://github.com/pahaz/sshtunnel/pull/301
  patches = [ ./paramiko-4.0-compat.patch ];

  build-system = [ setuptools ];

  dependencies = [ paramiko ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  # disable impure tests
  disabledTests = [
    "test_get_keys"
    "connect_via_proxy"
    "read_ssh_config"
    # Test doesn't work with paramiko < 4.0.0 and the patch above
    "test_read_private_key_file"
  ];

  meta = with lib; {
    description = "Pure python SSH tunnels";
    mainProgram = "sshtunnel";
    homepage = "https://github.com/pahaz/sshtunnel";
    license = licenses.mit;
    maintainers = [ ];
  };
}
