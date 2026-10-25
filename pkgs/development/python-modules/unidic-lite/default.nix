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
    hash = "sha256-251Fctn91NAKl5SdSwdB7EgO4Fp+fi4y9UdQDa4nskU=";
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
