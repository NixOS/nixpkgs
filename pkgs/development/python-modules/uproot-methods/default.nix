{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.4.2";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dcb72692067cfc4c5ccfa859fe737b2cd47661692a0cc0b42c75d13dbb1eb040";
  };

  propagatedBuildInputs = [ numpy awkward ];

  meta = with stdenv.lib; {
    homepage = https://github.com/scikit-hep/uproot-methods;
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
