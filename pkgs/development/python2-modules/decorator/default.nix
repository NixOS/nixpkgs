{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "decorator";
  version = "4.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rxzhk5zwiggk45hl53zydvy70lk654kg0nc1p54090p402jz9p3";
  };

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/decorator";
    description = "Better living through Python with decorators";
    license = lib.licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
