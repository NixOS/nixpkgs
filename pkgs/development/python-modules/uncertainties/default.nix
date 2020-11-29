{ stdenv, fetchPypi, buildPythonPackage
, nose, numpy, future
}:

buildPythonPackage rec {
  pname = "uncertainties";
  version = "3.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9122c1e7e074196883b4a7a946e8482807b2f89675cb5e3798b87e0608ede903";
  };

  propagatedBuildInputs = [ future ];
  checkInputs = [ nose numpy ];

  checkPhase = "python setup.py nosetests -sv";

  meta = with stdenv.lib; {
    homepage = "https://pythonhosted.org/uncertainties/";
    description = "Transparent calculations with uncertainties on the quantities involved (aka error propagation)";
    maintainers = with maintainers; [ rnhmjoj ];
    license = licenses.bsd3;
  };
}
