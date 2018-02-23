{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wsgiref";
  version = "0.1.2";
  src = fetchPypi {
    inherit pname version;
    extension = "zip"; # Oddly, the .tar.gz gives a 404.
    sha256 = "0y8fyjmpq7vwwm4x732w97qbkw78rjwal5409k04cw4m03411rn7";
  };

  meta = with lib; {
    homepage = https://pypi.python.org/pypi/wsgiref;
    license = with licenses; [ psfl zpl21 ];
    description = "WSGI (PEP 333) Reference Library";
  };
}
