{
  buildPythonPackage,
  fetchPypi,
  lib,
  whey,
  sphinx,
  apeye,
  autodocsumm,
  beautifulsoup4,
  cachecontrol,
  dict2css,
  filelock,
  html5lib,
  ruamel-yaml,
  sphinx-autodoc-typehints,
  sphinx-jinja2-compat,
  sphinx-prompt,
  sphinx-tabs,
  tabulate,
  python,
}:
buildPythonPackage rec {
  pname = "sphinx-toolbox";
  version = "4.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinx_toolbox";
    hash = "sha256-SMMUUdsuLYxxwDk55yoZ73vJLKeFCmLbY/x7uDlbZ4U=";
  };

  postPatch = ''
    substituteInPlace \
      requirements.txt PKG-INFO pyproject.toml \
      --replace-fail "sphinx-tabs<3.4.7,>=1.2.1" "sphinx-tabs<=3.4.7,>=1.2.1"
  '';

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
    ruamel-yaml
    sphinx-autodoc-typehints
    sphinx-jinja2-compat
    sphinx-prompt
    sphinx-tabs
    tabulate
  ];

  # Not PEP420 compliant, some variables are imported from within the package.
  postFixup = ''
    echo '__version__: str = "${version}"' > $out/${python.sitePackages}/sphinx_toolbox/__init__.py
  '';

  meta = {
    description = "Box of handy tools for Sphinx";
    homepage = "https://github.com/sphinx-toolbox/sphinx-toolbox";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
