{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "tlslite";
  version = "0.4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b9a487694c239efea8cec4454a99a56ee1ae1a5f3af0858ccf8029e2ac2d42d";
  };

  meta = with lib; {
    description = "Pure Python implementation of SSL and TLS";
    homepage = "https://pypi.python.org/pypi/tlslite";
    license = licenses.bsd3;
  };
}
