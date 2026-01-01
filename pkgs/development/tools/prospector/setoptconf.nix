{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "setoptconf-tmp";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y2pgpraa36wzlzkxigvmz80mqd3mzcc9wv2yx9bliqks7fhlj70";
  };

  # Base tests provided via PyPi are broken
  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://pypi.org/project/setoptconf-tmp";
    description = "Module for retrieving program settings from various sources in a consistant method";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    homepage = "https://pypi.org/project/setoptconf-tmp";
    description = "Module for retrieving program settings from various sources in a consistant method";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      kamadorueda
    ];
  };
}
