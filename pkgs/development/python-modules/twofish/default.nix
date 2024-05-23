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
    sha256 = "1yihp2n42amrxw0wk9f66llpb3w5kwhgkcdg9krkzcik1nsqp7dh";
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
