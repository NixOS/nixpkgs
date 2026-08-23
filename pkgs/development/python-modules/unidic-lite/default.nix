{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "unidic-lite";
  version = "1.0.8";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "0idj4yp0sl27ylr2wzkybbh0wj7c843lp7cljw5d1m7xv5r4b7fv";
  };

  build-system = [ setuptools ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "unidic_lite" ];

  meta = {
    description = "Small version of UniDic";
    homepage = "https://github.com/polm/unidic-lite";
    license = lib.licenses.mit;
    teams = [ lib.teams.tts ];
  };
})
