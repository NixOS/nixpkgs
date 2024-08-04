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
  version = "0.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "py-shiny";
    rev = "refs/tags/v${version}";
    hash = "sha256-s1j9bMAapO0iRXsuNxiwlNaVv2EoWcl9U7WnHwQe9n8=";
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
    changelog = "https://github.com/posit-dev/py-shiny/blob/${src.rev}/CHANGELOG.md";
    description = "Build fast, beautiful web applications in Python";
    license = lib.licenses.mit;
    homepage = "https://shiny.posit.co/py";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
