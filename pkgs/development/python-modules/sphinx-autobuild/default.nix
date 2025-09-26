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
  version = "2025.08.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = "sphinx-autobuild";
    tag = version;
    hash = "sha256-JfhLC1924bU1USvoYwluFGdxxahS+AfRSHnGlLfE0NY=";
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
