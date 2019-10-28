{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "waitress";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "278e09d6849acc1365404bbf7d790d0423b159802e850c726e8cd0a126a2dac7";
  };

  doCheck = false;

  meta = with stdenv.lib; {
     homepage = https://github.com/Pylons/waitress;
     description = "Waitress WSGI server";
     license = licenses.zpl20;
     maintainers = with maintainers; [ domenkozar ];
  };

}
