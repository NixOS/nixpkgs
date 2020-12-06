{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.9.1";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "accb4392c59a1485ce3ee6d78a6fd163731ade8b9b5208e7bde8fa1767aef097";
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
