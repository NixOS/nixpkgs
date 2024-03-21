{ lib
, buildPythonPackage
, pythonPackages
, fetchPypi
}:

buildPythonPackage rec {
  pname = "timy";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LUyxIGzAEjScF8tJbfC3B4LGKGL0lFGcyC8YBhJdhKs=";
  };

  meta = with lib; {
    description = "Minimalist measurement of python code time";
    homepage = "https://github.com/ramonsaraiva/timy";
    license = licenses.mit;
    maintainers = with maintainers; [ flandweber ];
  };
}
