{ stdenv
, buildPythonPackage
, fetchPypi
, ecdsa
}:

buildPythonPackage rec {
  pname = "tlslite-ng";
  version = "0.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1aw7j50byzab0xwp50m5w5c14fzdzwk2law5a5bn6dn3i5fc6fw2";
  };

  buildInputs = [ ecdsa ];

  meta = with stdenv.lib; {
    description = "Pure python implementation of SSL and TLS.";
    homepage = https://pypi.python.org/pypi/tlslite-ng;
    license = licenses.lgpl2;
    maintainers = [ maintainers.erictapen ];
  };

}
