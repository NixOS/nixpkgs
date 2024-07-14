{
  buildPythonPackage,
  lib,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "1.0.1";
  format = "setuptools";
  pname = "unittest-data-provider";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hrx/tmCMJXCu7a3qNG/jA0r8lAgH3XUZ6V5dvImawr4=";
  };

  meta = with lib; {
    description = "PHPUnit-like @dataprovider decorator for unittest";
    homepage = "https://github.com/yourlabs/unittest-data-provider";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
