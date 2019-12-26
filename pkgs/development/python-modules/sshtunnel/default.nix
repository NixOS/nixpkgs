{ lib, buildPythonPackage, fetchPypi
, paramiko
, pytest
, mock
}:

buildPythonPackage rec {
  version = "0.1.5";
  pname = "sshtunnel";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jcjppp6mdfsqrbfc3ddfxg1ybgvkjv7ri7azwv3j778m36zs4y8";
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
