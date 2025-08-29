{
  lib,
  asgineer,
  bcrypt,
  buildPythonPackage,
  fetchFromGitHub,
  iptools,
  itemdb,
  jinja2,
  markdown,
  nodejs,
  pscript,
  pyjwt,
  pytestCheckHook,
  requests,
  setuptools,
  uvicorn,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "timetagger";
  version = "25.06.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = "timetagger";
    tag = "v${version}";
    hash = "sha256-fuZj4DoqtgIcRd/u7l0GsWqmuLEgF3BW5gN5wY8FdK0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asgineer
    bcrypt
    iptools
    itemdb
    jinja2
    markdown
    pscript
    pyjwt
    uvicorn
  ];

  nativeCheckInputs = [
    nodejs
    pytestCheckHook
    requests
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "timetagger" ];

  meta = {
    description = "Library to interact with TimeTagger";
    homepage = "https://github.com/almarklein/timetagger";
    changelog = "https://github.com/almarklein/timetagger/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "timetagger";
  };
}
