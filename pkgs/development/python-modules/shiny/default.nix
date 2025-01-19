{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  appdirs,
  asgiref,
  click,
  htmltools,
  linkify-it-py,
  markdown-it-py,
  mdit-py-plugins,
  python-multipart,
  questionary,
  starlette,
  uvicorn,
  watchfiles,
  websockets,

  pytestCheckHook,
  pytest-asyncio,
  pytest-playwright,
  pytest-xdist,
  pytest-timeout,
  pytest-rerunfailures,
  pandas,
}:

buildPythonPackage rec {
  pname = "shiny";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "py-shiny";
    tag = "v${version}";
    hash = "sha256-8bo2RHuIP7X7EaOlHd+2m4XU287owchAwiqPnpjKFjI=";
  };

  build-system = [ setuptools ];
  dependencies = [
    appdirs
    asgiref
    click
    htmltools
    linkify-it-py
    markdown-it-py
    mdit-py-plugins
    python-multipart
    questionary
    starlette
    uvicorn
    watchfiles
    websockets
  ];

  pythonImportsCheck = [ "shiny" ];
  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-playwright
    pytest-xdist
    pytest-timeout
    pytest-rerunfailures
    pandas
  ];

  meta = {
    changelog = "https://github.com/posit-dev/py-shiny/blob/${src.tag}/CHANGELOG.md";
    description = "Build fast, beautiful web applications in Python";
    license = lib.licenses.mit;
    homepage = "https://shiny.posit.co/py";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
