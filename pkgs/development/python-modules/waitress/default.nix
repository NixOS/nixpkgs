{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "waitress";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pw6yyxi348r2xpq3ykqnf7gwi881azv2422d2ixb0xi5jws2ky7";
  };

  doCheck = false;

  meta = with stdenv.lib; {
     homepage = https://github.com/Pylons/waitress;
     description = "Waitress WSGI server";
     license = licenses.zpl20;
     maintainers = with maintainers; [ garbas domenkozar ];
  };

}
