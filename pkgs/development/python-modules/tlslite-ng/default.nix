{ stdenv
, buildPythonPackage
, fetchPypi
, ecdsa
}:

buildPythonPackage rec {
  pname = "tlslite-ng";
  version = "0.7.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-arVvDpYpzj2AfrUoyREt76ny4AryspYSVOhCnKXB/wA=";
  };

  buildInputs = [ ecdsa ];

  meta = with stdenv.lib; {
    description = "Pure python implementation of SSL and TLS.";
    homepage = "https://pypi.python.org/pypi/tlslite-ng";
    license = licenses.lgpl2;
    maintainers = [ maintainers.erictapen ];
  };

}
