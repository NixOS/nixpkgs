{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.2.7";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc687d2144ff7b55e6858b4865beb15ae7a25d274212fb4436ead982993e2f31";
  };

  propagatedBuildInputs = [ numpy awkward ];

  meta = with stdenv.lib; {
    homepage = https://github.com/scikit-hep/uproot-methods;
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
