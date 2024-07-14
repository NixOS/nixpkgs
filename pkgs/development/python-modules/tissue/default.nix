{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
  pep8,
}:

buildPythonPackage rec {
  pname = "tissue";
  version = "0.9.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fjRybD7I+uNYp/r2LeFy2xVxb1WC5RkqEJ4zNIvXbC4=";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ pep8 ];

  meta = with lib; {
    homepage = "https://github.com/WoLpH/tissue";
    description = "Tissue - automated pep8 checker for nose";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ domenkozar ];
  };
}
