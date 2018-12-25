{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "update-copyright";
  version = "0.6.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "17ybdgbdc62yqhda4kfy1vcs1yzp78d91qfhj5zbvz1afvmvdk7z";
  };

  meta = with lib; {
    description = "An automatic copyright update tool";
    license = licenses.gpl3;
  };
}
