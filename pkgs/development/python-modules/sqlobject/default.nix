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
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p2dxrxh7xrv5yys09v5z95d0z40w22aq3xc01ghdidd7hr79xy9";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ FormEncode PasteDeploy paste pydispatcher ];

  meta = with stdenv.lib; {
    description = "Object Relational Manager for providing an object interface to your database";
    homepage = "http://www.sqlobject.org/";
    license = licenses.lgpl21;
  };

}
