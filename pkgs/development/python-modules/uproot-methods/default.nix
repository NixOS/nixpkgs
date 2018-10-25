{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.2.5";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d5563b3335af414a12caf5b350c952fdc7576abb17630382de5564a7c254ae6";
  };

  propagatedBuildInputs = [ numpy awkward ];

  meta = with stdenv.lib; {
    homepage = https://github.com/scikit-hep/uproot-methods;
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
