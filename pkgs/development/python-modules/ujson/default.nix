{ stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
}:

buildPythonPackage rec {
  pname = "ujson";
  version = "1.35";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "11jz5wi7mbgqcsz52iqhpyykiaasila4lq8cmc2d54bfa3jp6q7n";
  };

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/ujson;
    description = "Ultra fast JSON encoder and decoder for Python";
    license = licenses.bsd3;
  };

}
