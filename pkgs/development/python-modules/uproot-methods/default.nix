{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.7.2";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4382983e4e6c5e1aeb3013d04334907f87f62b0d7c19a29968e5a0aac1653ae1";
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
