{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "update-copyright";
  version = "0.6.2";
  format = "setuptools";

  disabled = !isPy3k;

  # Has no tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/8y263Yq/L1+kdDhkBo69/ug2Q7eTaIaxF4Y1tZry58=";
  };

  meta = with lib; {
    description = "Automatic copyright update tool";
    mainProgram = "update-copyright.py";
    homepage = "http://blog.tremily.us/posts/update-copyright";
    license = licenses.gpl3;
  };
}
