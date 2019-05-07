{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.4.7";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a00d1db828c44d2ba35801aeff7d1ea890b7dfa337895395e3b06284c14857b";
  };

  propagatedBuildInputs = [ numpy awkward ];

  meta = with stdenv.lib; {
    homepage = https://github.com/scikit-hep/uproot-methods;
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
