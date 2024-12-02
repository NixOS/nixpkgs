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
  version = "2024.09.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = "sphinx-autobuild";
    rev = "refs/tags/${version}";
    hash = "sha256-azSQ524iXWeW7D1NgpWErFL4K0TBZ8ib6lRr1J246h4=";
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
