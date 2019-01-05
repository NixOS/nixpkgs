{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "waitress";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d33cd3d62426c0f1b3cd84ee3d65779c7003aae3fc060dee60524d10a57f05a9";
  };

  doCheck = false;

  meta = with stdenv.lib; {
     homepage = https://github.com/Pylons/waitress;
     description = "Waitress WSGI server";
     license = licenses.zpl20;
     maintainers = with maintainers; [ garbas domenkozar ];
  };

}
