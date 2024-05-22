{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "waitress";
  version = "3.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AF2kebBBNM3Z3WAtHufEnXneBTdhDWU2dMxsveIiuKE=";
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
