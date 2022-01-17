{ lib, python2Packages, fetchFromGitHub }:

python2Packages.buildPythonApplication rec {
  pname = "py-wmi-client";
  version = "unstable-20160601";

  src = fetchFromGitHub {
    owner = "dlundgren";
    repo = pname;
    rev = "9702b036df85c3e0ecdde84a753b353069f58208";
    sha256 = "1kd12gi1knqv477f1shzqr0h349s5336vzp3fpfp3xl0b502ld8d";
  };

  propagatedBuildInputs = with python2Packages; [ impacket natsort pyasn1 pycrypto ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Python WMI Client implementation";
    homepage = "https://github.com/dlundgren/py-wmi-client";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
