{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "terminaltables";
  version = "3.1.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ba6eca5cb5ba02bba4c9f4f985af80c54ec3dccf94cfcd190154386255e47543";
  };

  meta = with lib; {
    description = "Display simple tables in terminals";
    homepage = "https://github.com/Robpol86/terminaltables";
    license = licenses.mit;
  };

}
