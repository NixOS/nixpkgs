{
  buildPythonPackage,
  fetchPypi,
  lib,

  # pythonPackages
  javaobj-py3,
}:

buildPythonPackage rec {
  pname = "twofish";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sJ2LtQ0zsj/zTK+x+SCfhY91KTXGpckB77kqQay4MPo=";
  };

  propagatedBuildInputs = [ javaobj-py3 ];

  # No tests implemented
  doCheck = false;

  meta = {
    description = "Bindings for the Twofish implementation by Niels Ferguson";
    homepage = "https://github.com/keybase/python-twofish";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
