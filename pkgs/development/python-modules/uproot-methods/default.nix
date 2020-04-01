{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.7.3";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01x7raa2l75g96y6fsi6h2fjpjm0swlnw0j9vn8mlahridycrjss";
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
