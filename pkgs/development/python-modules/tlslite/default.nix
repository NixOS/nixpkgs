{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "tlslite";
  version = "0.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fxx6d3nw5r1hqna1h2jvqhcygn9fyshlm0gh3gp0b1ji824gd6r";
  };

  meta = with stdenv.lib; {
    description = "A pure Python implementation of SSL and TLS";
    homepage = https://pypi.python.org/pypi/tlslite;
    license = licenses.bsd3;
  };

}
