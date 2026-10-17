{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "ytmusicapi";
  version = "1.12.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sigma67";
    repo = "ytmusicapi";
    tag = version;
    hash = "sha256-mIxtr018hE3LSJCJdD2Lr8UUOic8m2rmPwU86EJuLFk=";
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
