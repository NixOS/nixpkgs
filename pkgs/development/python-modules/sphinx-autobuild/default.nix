{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  colorama,
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
  version = "2024.04.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = "sphinx-autobuild";
    rev = "refs/tags/${version}";
    hash = "sha256-5HgRqt2ZTGcQ6X2sZN0gRfahmwlqpDbae5gOnGa02L0=";
  };

  build-system = [ flit-core ];

  dependencies = [
    colorama
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
