{
  lib,
  buildPythonPackage,
  fetchPypi,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "stringly";
  version = "1.0b2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+N6/EDPXVWrPNaZNRpW/ONXILzy6cl5BxGQf4V5L0SU=";
  };

  pythonImportsCheck = [ "stringly" ];

  propagatedBuildInputs = [ typing-extensions ];

  meta = with lib; {
    description = "Stringly: Human Readable Object Serialization";
    homepage = "https://github.com/evalf/stringly";
    license = licenses.mit;
    maintainers = [ maintainers.Scriptkiddi ];
  };
}
