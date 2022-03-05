{ lib, buildPythonPackage, fetchPypi
, itsdangerous, click, werkzeug, jinja2, pytest }:

buildPythonPackage rec {
  version = "1.1.2";
  pname = "Flask";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4efa1ae2d7c9865af48986de8aeb8504bf32c7f3d6fdc9353d34b21f4b127060";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ itsdangerous click werkzeug jinja2 ];

  checkPhase = ''
    py.test
  '';

  # Tests require extra dependencies
  doCheck = false;

  meta = with lib; {
    homepage = "http://flask.pocoo.org/";
    description = "A microframework based on Werkzeug, Jinja 2, and good intentions";
    license = licenses.bsd3;
  };
}
