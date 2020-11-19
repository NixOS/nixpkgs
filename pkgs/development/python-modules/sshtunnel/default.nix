{ lib, buildPythonPackage, fetchPypi
, paramiko
, pytest
, mock
}:

buildPythonPackage rec {
  version = "0.2.2";
  pname = "sshtunnel";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1801b144b42b9bdb2f931923e85837f9193b877f3d490cd5776e1d4062c62fb4";
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
