{
  lib,
  apeye,
  autodocsumm,
  beautifulsoup4,
  buildPythonPackage,
  cachecontrol,
  dict2css,
  fetchPypi,
  filelock,
  html5lib,
  python,
  roman,
  ruamel-yaml,
  sphinx-autodoc-typehints,
  sphinx-jinja2-compat,
  sphinx-prompt,
  sphinx-tabs,
  sphinx,
  tabulate,
  whey,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinx-toolbox";
  version = "4.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "sphinx_toolbox";
    hash = "sha256-B+wmF2dE7jq+PB60QHQZ6BRo9FNvMy3K/E4yQLDW+uI=";
  };

  pythonRelaxDeps = [
    "ruamel.yaml"
    "sphinx-autodoc-typehints"
    "sphinx-tabs"
  ];

  build-system = [ whey ];

  dependencies = [
    sphinx
    apeye
    autodocsumm
    beautifulsoup4
    cachecontrol
    dict2css
    filelock
    html5lib
    roman
    ruamel-yaml
    sphinx-autodoc-typehints
    sphinx-jinja2-compat
    sphinx-prompt
    sphinx-tabs
    tabulate
  ];

  # Not PEP420 compliant, some variables are imported from within the package.
  postFixup = ''
    echo '__version__: str = "${finalAttrs.version}"' > $out/${python.sitePackages}/sphinx_toolbox/__init__.py
  '';

  meta = {
    description = "Box of handy tools for Sphinx";
    homepage = "https://github.com/sphinx-toolbox/sphinx-toolbox";
    changelog = "https://github.com/sphinx-toolbox/sphinx-toolbox/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
