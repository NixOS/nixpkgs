{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.2.11";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "289b9b4a58511f35ab4783bb37cdc922eba75d1886e0eb1be136cc861eff7b66";
  };

  propagatedBuildInputs = [ numpy awkward ];

  meta = with stdenv.lib; {
    homepage = https://github.com/scikit-hep/uproot-methods;
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
