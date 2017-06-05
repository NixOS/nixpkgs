{ stdenv, fetchurl, buildPythonPackage, dns, pyasn1 }:

buildPythonPackage rec {
  name = "sleekxmpp-${version}";
  version = "1.3.1";

  propagatedBuildInputs = [ dns pyasn1 ];

  patches = [
    ./dnspython-ip6.patch
  ];

  src = fetchurl {
    url = "mirror://pypi/s/sleekxmpp/${name}.tar.gz";
    sha256 = "1krkhkvj8xw5a6c2xlf7h1rg9xdcm9d8x2niivwjahahpvbl6krr";
  };

  meta = with stdenv.lib; {
    description = "XMPP library for Python";
    license = licenses.mit;
    homepage = "http://sleekxmpp.com/";
  };
}
