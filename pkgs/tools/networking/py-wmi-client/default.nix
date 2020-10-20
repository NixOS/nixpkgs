{ lib, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonApplication rec {
  pname = "py-wmi-client-unstable";
  version = "20160601";

  src = fetchFromGitHub {
    owner = "dlundgren";
    repo = "py-wmi-client";
    rev = "9702b036df85c3e0ecdde84a753b353069f58208";
    sha256 = "1kd12gi1knqv477f1shzqr0h349s5336vzp3fpfp3xl0b502ld8d";
  };

  propagatedBuildInputs = with pythonPackages; [ impacket natsort pyasn1 pycrypto ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Python WMI Client implementation";
    homepage = "https://github.com/dlundgren/py-wmi-client";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
