{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "waitress";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "780a4082c5fbc0fde6a2fcfe5e26e6efc1e8f425730863c04085769781f51eba";
  };

  doCheck = false;

  meta = with lib; {
     homepage = "https://github.com/Pylons/waitress";
     description = "Waitress WSGI server";
     license = licenses.zpl20;
     maintainers = with maintainers; [ domenkozar ];
  };

}
