{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "ytmusicapi";
  version = "1.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sigma67";
    repo = "ytmusicapi";
    tag = version;
    hash = "sha256-Q7+vc8wc4imHBHImAvxQZHkk3dT4HM3BifDivNjCMtU=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ requests ];

  doCheck = false; # requires network access

  pythonImportsCheck = [ "ytmusicapi" ];

  meta = with lib; {
    description = "Python API for YouTube Music";
    homepage = "https://github.com/sigma67/ytmusicapi";
    changelog = "https://github.com/sigma67/ytmusicapi/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "ytmusicapi";
  };
}
