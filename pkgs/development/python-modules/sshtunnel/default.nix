{ lib, buildPythonPackage, fetchPypi
, paramiko
, pytest
, mock
}:

buildPythonPackage rec {
  version = "0.3.1";
  pname = "sshtunnel";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e0cac8a6a154c7a9651b42038e3f6cf35bb88c8ee4b94822b28a5b2fe7140f95";
  };

  propagatedBuildInputs = [ paramiko ];

  checkInputs = [ pytest mock ];

  # disable impure tests
  checkPhase = ''
    pytest -k 'not connect_via_proxy and not read_ssh_config'
  '';

  meta = with lib; {
    description = "Pure python SSH tunnels";
    homepage = "https://github.com/pahaz/sshtunnel";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
