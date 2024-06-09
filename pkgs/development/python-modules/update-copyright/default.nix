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
    sha256 = "17ybdgbdc62yqhda4kfy1vcs1yzp78d91qfhj5zbvz1afvmvdk7z";
  };

  meta = with lib; {
    description = "An automatic copyright update tool";
    mainProgram = "update-copyright.py";
    homepage = "http://blog.tremily.us/posts/update-copyright";
    license = licenses.gpl3;
  };
}
