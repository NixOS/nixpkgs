{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "waitress";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2e60576cf14a1539da79f7b7ee1e79a71e64f366a0b47db54a15e971f57bb16";
  };

  doCheck = false;

  meta = with lib; {
     homepage = "https://github.com/Pylons/waitress";
     description = "Waitress WSGI server";
     license = licenses.zpl20;
     maintainers = with maintainers; [ domenkozar ];
  };

}
