{ lib, buildPythonPackage, fetchPypi
, paramiko
, pytest
, mock
}:

buildPythonPackage rec {
  version = "0.2.1";
  pname = "sshtunnel";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce28bf9abe6c6b00c5d10343a68c1325f8409ebfb9bf1c1d863a31afa3983cd7";
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
