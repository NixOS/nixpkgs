{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.7.1";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d7bfcc84c28a0b61669232ad43b86bbb944504f6bf4612fd395f4e5cc45d0ba5";
  };

  propagatedBuildInputs = [ numpy awkward ];

  # No tests on PyPi
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/scikit-hep/uproot-methods;
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
