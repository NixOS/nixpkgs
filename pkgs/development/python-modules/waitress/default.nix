{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "waitress";
  version = "3.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7wwfAg2fEqUVxOxlwHkgpwJhOvytHb/cO87CVrbAcrM=";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Pylons/waitress";
    description = "Waitress WSGI server";
    mainProgram = "waitress-serve";
    license = licenses.zpl20;
    maintainers = with maintainers; [ domenkozar ];
  };
}
