{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  fastcore,
  ipywidgets,
  jupyter,
  stqdm,
  streamlit,
  tabulate,
  tqdm,
}:

buildPythonPackage rec {
  pname = "streamlit-jupyter";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ddobrinskiy";
    repo = "streamlit-jupyter";
    tag = "v${version}";
    hash = "sha256-JVoLhb8h6fz/x315MzrccRjgmgIgnYR0hqTr5zdm2MA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    fastcore
    ipywidgets
    jupyter
    stqdm
    streamlit
    tabulate
    tqdm
  ];

  pythonImportsCheck = [ "streamlit_jupyter" ];

  meta = {
    homepage = "https://ddobrinskiy.github.io/streamlit-jupyter/readme.html";
    description = "Preview and develop streamlit apps in jupyter notebooks";
    maintainers = with lib.maintainers; [ Luflosi ];
    license = lib.licenses.asl20;
  };
}
