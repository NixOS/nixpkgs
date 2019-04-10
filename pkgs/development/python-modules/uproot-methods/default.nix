{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.4.4";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "004q7lywhhdvsmds88cfpjvkj89nf8n9d4gyrbvvj3x0gw7iiljq";
  };

  propagatedBuildInputs = [ numpy awkward ];

  meta = with stdenv.lib; {
    homepage = https://github.com/scikit-hep/uproot-methods;
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
