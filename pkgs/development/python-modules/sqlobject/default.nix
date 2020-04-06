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
  version = "3.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00fb93313067cdbe52fe436eef1e79038b42c969cf44016b24f9eae0511db2d7";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ FormEncode PasteDeploy paste pydispatcher ];

  meta = with stdenv.lib; {
    description = "Object Relational Manager for providing an object interface to your database";
    homepage = "http://www.sqlobject.org/";
    license = licenses.lgpl21;
  };

}
