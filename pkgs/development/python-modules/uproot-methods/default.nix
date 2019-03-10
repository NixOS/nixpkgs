{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.4.3";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f90d91a613a875ebdf214f0f6f3fd0f8beea9125fc35e54f334d6104fe47c87d";
  };

  propagatedBuildInputs = [ numpy awkward ];

  meta = with stdenv.lib; {
    homepage = https://github.com/scikit-hep/uproot-methods;
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
