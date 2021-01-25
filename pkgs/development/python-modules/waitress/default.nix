{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "waitress";
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bb436508a7487ac6cb097ae7a7fe5413aefca610550baf58f0940e51ecfb261";
  };

  doCheck = false;

  meta = with lib; {
     homepage = "https://github.com/Pylons/waitress";
     description = "Waitress WSGI server";
     license = licenses.zpl20;
     maintainers = with maintainers; [ domenkozar ];
  };

}
