{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "terminaltables";
  version = "3.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5dab2f33927c0a020b8011c81b92830ff9fd4ba701657da5d7bfdc41048360a6";
  };

  meta = with lib; {
    description = "Display simple tables in terminals";
    homepage = "https://github.com/Robpol86/terminaltables";
    license = licenses.mit;
  };

}
