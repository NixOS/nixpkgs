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
  version = "3.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "620657105ab5720658222d10ad13c52281fe524137b59ab166eee4427ee2f548";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ FormEncode PasteDeploy paste pydispatcher ];

  meta = with stdenv.lib; {
    description = "Object Relational Manager for providing an object interface to your database";
    homepage = "http://www.sqlobject.org/";
    license = licenses.lgpl21;
  };

}
