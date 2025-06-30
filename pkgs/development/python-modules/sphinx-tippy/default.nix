{
  lib,
  buildPythonPackage,
  fetchPypi,
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

  src = fetchPypi {
    pname = "sphinx_tippy";
    inherit version;
    hash = "sha256-JVq+4K7YCF/bmrDMWVzXpFdIrn9GYhVuUAoXo/c61j0=";
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
    homepage = "https://pypi.org/project/sphinx_tippy/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
