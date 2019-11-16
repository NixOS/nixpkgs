{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, FormEncode
, PasteDeploy
, paste
, pydispatcher
}:

buildPythonPackage rec {
  pname = "SQLObject";
  version = "3.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dgzmzdv3alfdqcrl4x0xf9161ls80h33rnqbz0yhmfpkjg99b9n";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ FormEncode PasteDeploy paste pydispatcher ];

  meta = with stdenv.lib; {
    description = "Object Relational Manager for providing an object interface to your database";
    homepage = "http://www.sqlobject.org/";
    license = licenses.lgpl21;
  };

}
