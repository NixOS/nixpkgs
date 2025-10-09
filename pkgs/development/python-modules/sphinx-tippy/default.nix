{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  beautifulsoup4,
  jinja2,
  requests,
  sphinx,
  sphinxHook,
  furo,
  myst-parser,
}:

buildPythonPackage rec {
  pname = "sphinx-tippy";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-extensions2";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-+EXvj8Q6eMu51Gh4hLD6h8I7PDZaeVH+2pZuQUMVH+4=";
  };

  build-system = [
    flit-core
  ];

  nativeBuildInputs = [
    sphinxHook
    furo
    myst-parser
  ];

  dependencies = [
    beautifulsoup4
    jinja2
    requests
    sphinx
  ];

  pythonImportsCheck = [
    "sphinx_tippy"
  ];

  meta = {
    description = "Get rich tool tips in your sphinx documentation";
    homepage = "https://sphinx-tippy.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
