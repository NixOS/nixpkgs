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
  version = "3.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f0a5d9430c40b9fa5065e210a7fd3aaabb0713313e72b1b7b7dc4c7d62e43d2";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ FormEncode PasteDeploy paste pydispatcher ];

  meta = with stdenv.lib; {
    description = "Object Relational Manager for providing an object interface to your database";
    homepage = "http://www.sqlobject.org/";
    license = licenses.lgpl21;
  };

}
