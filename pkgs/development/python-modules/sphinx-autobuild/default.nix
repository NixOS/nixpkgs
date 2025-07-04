{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  colorama,
  httpx,
  sphinx,
  starlette,
  uvicorn,
  watchfiles,
  websockets,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinx-autobuild";
  version = "2024.10.03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = "sphinx-autobuild";
    tag = version;
    hash = "sha256-RUPyOI0DYmpbemSIA2pNjlE5T4PEAE84yvWbcula0qs=";
  };

  build-system = [ flit-core ];

  dependencies = [
    colorama
    httpx
    sphinx
    starlette
    uvicorn
    watchfiles
    websockets
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sphinx_autobuild" ];

  meta = with lib; {
    description = "Rebuild Sphinx documentation on changes, with live-reload in the browser";
    mainProgram = "sphinx-autobuild";
    homepage = "https://github.com/sphinx-doc/sphinx-autobuild";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ holgerpeters ];
  };
}
