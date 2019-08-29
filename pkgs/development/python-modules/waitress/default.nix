{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "waitress";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c369e238bd81ef7d61f04825f06f107c42094de60d13d8de8e71952c7c683dfe";
  };

  doCheck = false;

  meta = with stdenv.lib; {
     homepage = https://github.com/Pylons/waitress;
     description = "Waitress WSGI server";
     license = licenses.zpl20;
     maintainers = with maintainers; [ domenkozar ];
  };

}
