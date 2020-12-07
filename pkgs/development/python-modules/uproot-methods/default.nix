{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.9.2";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e1b424582f8c48cd18c60bef71c81d1bd19c3f4b0bc34f329458958a65dce35";
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
