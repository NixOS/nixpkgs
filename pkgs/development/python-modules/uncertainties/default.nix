{ stdenv, fetchPypi, buildPythonPackage
, nose, numpy, future
}:

buildPythonPackage rec {
  pname = "uncertainties";
  version = "3.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s69kdhl8vhqazhxqdvb06l83x0iqdm0yr4vp3p52alzi6a8lm33";
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
