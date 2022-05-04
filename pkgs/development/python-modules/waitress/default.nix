{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "waitress";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4uYFds8UoVOdp597fuHnmnHmTzZqC0fbVKFelx9XuxY=";
  };

  doCheck = false;

  meta = with lib; {
     homepage = "https://github.com/Pylons/waitress";
     description = "Waitress WSGI server";
     license = licenses.zpl20;
     maintainers = with maintainers; [ domenkozar ];
  };

}
