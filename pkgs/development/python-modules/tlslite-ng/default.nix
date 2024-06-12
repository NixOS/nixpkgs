{
  lib,
  buildPythonPackage,
  fetchPypi,
  ecdsa,
}:

buildPythonPackage rec {
  pname = "tlslite-ng";
  version = "0.7.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ab56f0e9629ce3d807eb528c9112defa9f2e00af2b2961254e8429ca5c1ff00";
  };

  buildInputs = [ ecdsa ];

  meta = with lib; {
    description = "Pure python implementation of SSL and TLS";
    homepage = "https://pypi.python.org/pypi/tlslite-ng";
    license = licenses.lgpl2;
    maintainers = [ ];
  };
}
