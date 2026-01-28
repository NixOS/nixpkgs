{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  html5tagger,
  ipykernel,
  ipywidgets,
  jupyter,
  jupyter-client,
  jupyterlab,
  notebook,

  # tests
  pytestCheckHook,
  beautifulsoup4,
  torch,
}:

buildPythonPackage rec {
  pname = "tracerite";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "tracerite";
    tag = "v${version}";
    hash = "sha256-UXIQc5rXVaZuZj5xu2X9H38vKWAM+AoKrKfudovUhwA=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    html5tagger
  ];

  optional-dependencies.nb = [
    ipykernel
    ipywidgets
    jupyter
    jupyter-client
    jupyterlab
    notebook
  ];

  postInstall = ''
    cp tracerite/{script.js,style.css} $out/${python.sitePackages}/tracerite
  '';

  nativeCheckInputs = [
    pytestCheckHook
    beautifulsoup4
    torch
  ];

  pythonImportsCheck = [ "tracerite" ];

  meta = {
    description = "Tracebacks for Humans in Jupyter notebooks";
    homepage = "https://github.com/sanic-org/tracerite";
    changelog = "https://github.com/sanic-org/tracerite/releases/tag/${src.tag}";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ p0lyw0lf ];
  };
}
