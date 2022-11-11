{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, flit-core
, pytestCheckHook
}:

let
  pname = "socksio";
  version = "1.0.0";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+IvrPaW1w4uYkEad5n0MsPnUlLeLEGyhhF+WwQuRxKw=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # remove coverage configuration
  preCheck = ''
    rm pytest.ini
  '';

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Sans-I/O implementation of SOCKS4, SOCKS4A, and SOCKS5";
    homepage = "https://github.com/sethmlarson/socksio";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
