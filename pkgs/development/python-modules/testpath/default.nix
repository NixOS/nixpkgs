{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "testpath";
  version = "0.5.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "8044f9a0bab6567fc644a3593164e872543bb44225b0e24846e2c89237937589";
  };

  meta = with lib; {
    description = "Test utilities for code working with files and commands";
    license = licenses.mit;
    homepage = "https://github.com/jupyter/testpath";
  };

}
