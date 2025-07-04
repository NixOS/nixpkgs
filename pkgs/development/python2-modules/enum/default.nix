{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  isPyPy,
}:

buildPythonPackage rec {
  pname = "enum";
  version = "0.4.7";
  format = "setuptools";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "001iq0yqs9f5bslvl793bhkcs71k5km9kv8yrj5h0lfsgrcg6z4c";
  };

  doCheck = !isPyPy;

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/enum/";
    description = "Robust enumerated type support in Python";
    license = licenses.gpl2;
  };

}
