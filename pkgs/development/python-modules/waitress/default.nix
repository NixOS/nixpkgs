{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "waitress";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "69e1f242c7f80273490d3403c3976f3ac3b26e289856936d1f620ed48f321897";
  };

  doCheck = false;

  meta = with lib; {
     homepage = "https://github.com/Pylons/waitress";
     description = "Waitress WSGI server";
     license = licenses.zpl20;
     maintainers = with maintainers; [ domenkozar ];
  };

}
