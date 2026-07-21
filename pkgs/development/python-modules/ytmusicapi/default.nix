{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "ytmusicapi";
  version = "1.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sigma67";
    repo = "ytmusicapi";
    tag = version;
    hash = "sha256-9K61PJz+edCdLv8HiuASV4Bn3Tpw4JsCbIQNn24LjSU=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ requests ];

  doCheck = false; # requires network access

  pythonImportsCheck = [ "ytmusicapi" ];

  meta = {
    description = "Python API for YouTube Music";
    homepage = "https://github.com/sigma67/ytmusicapi";
    changelog = "https://github.com/sigma67/ytmusicapi/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "ytmusicapi";
  };
}
