{ lib, fetchPypi, buildPythonPackage, dns, pyasn1 }:

buildPythonPackage rec {
  pname = "sleekxmpp";
  version = "1.3.3";

  propagatedBuildInputs = [ dns pyasn1 ];

  patches = [
    ./dnspython-ip6.patch
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "d213c1de71d92505f95ced0460ee0f84fdc4ddcacb7d7dd343739ed4028e5569";
  };

  meta = with lib; {
    description = "XMPP library for Python";
    license = licenses.mit;
    homepage = "http://sleekxmpp.com/";
  };

}
