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

<<<<<<< HEAD
  meta = {
    description = "Small version of UniDic";
    homepage = "https://github.com/polm/unidic-lite";
    license = lib.licenses.mit;
    teams = [ lib.teams.tts ];
=======
  meta = with lib; {
    description = "Small version of UniDic";
    homepage = "https://github.com/polm/unidic-lite";
    license = licenses.mit;
    teams = [ teams.tts ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
