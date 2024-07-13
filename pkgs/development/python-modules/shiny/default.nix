{
  lib,
  buildPythonPackage,
  appdirs,
  asgiref,
  click,
  coverage,
  fetchFromGitHub,
  htmltools,
  linkify-it-py,
  markdown-it-py,
  mdit-py-plugins,
  packaging,
  pandas,
  playwright,
  pytest-asyncio,
  pytest-cov,
  pytest-playwright,
  pytest-rerunfailures,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  python-multipart,
  questionary,
  setuptools,
  starlette,
  typing-extensions,
  uvicorn,
  watchfiles,
  websockets,
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

  nativeBuildInputs = [ setuptools ];

  dependencies = [
    appdirs
    asgiref
    click
    htmltools
    linkify-it-py
    markdown-it-py
    mdit-py-plugins
    packaging
    python-multipart
    questionary
    starlette
    typing-extensions
    uvicorn
    watchfiles
    websockets
  ];

  nativeCheckInputs = [
    coverage
    pandas
    playwright
    pytest-asyncio
    pytest-cov
    pytest-playwright
    pytest-rerunfailures
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "shiny" ];

  meta = {
    description = "Shiny for Python";
    homepage = "https://github.com/posit-dev/py-shiny";
    changelog = "https://github.com/posit-dev/py-shiny/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "shiny";
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
