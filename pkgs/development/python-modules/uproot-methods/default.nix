{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.8.0";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57da3d67e1a42b548020debdd23285b5710e3bb2aac20eb7b2d2a686822aa1ab";
  };

  propagatedBuildInputs = [ numpy awkward ];

  # No tests on PyPi
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/scikit-hep/uproot-methods";
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
