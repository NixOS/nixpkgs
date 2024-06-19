{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "unidic-lite";
  version = "1.0.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0idj4yp0sl27ylr2wzkybbh0wj7c843lp7cljw5d1m7xv5r4b7fv";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "unidic_lite" ];

  meta = with lib; {
    description = "A small version of UniDic";
    homepage = "https://github.com/polm/unidic-lite";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
