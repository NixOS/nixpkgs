{ lib
, fetchFromGitHub, buildPythonApplication
, setuptools, setproctitle, stem, future, pyyaml, cryptography, pycrypto
, pexpect, mock, pytest, pytest-mock, tox
}:

buildPythonApplication rec {
  pname = "onionbalance";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "asn-d6";
    repo = "onionbalance";
    rev =  version;
    sha256 = "0v2rrc7y6blxvsxg04yqn81sjwymi09wwm7mdgmh53zc0ryh9zv6";
  };

  propagatedBuildInputs = [ setuptools setproctitle stem pyyaml cryptography pycrypto future ];

  checkInputs = [ pexpect mock pytest pytest-mock tox ];

  meta = with lib; {
    description = "OnionBalance provides load-balancing and redundancy for Tor hidden services";
    homepage = "https://onionbalance.readthedocs.org/";
    maintainers = with maintainers; [ colemickens ];
    license = licenses.gpl3;
  };
}
