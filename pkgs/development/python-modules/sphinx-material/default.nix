{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  css-html-js-minify,
  fetchPypi,
  lxml,
  python-slugify,
  setuptools,
  sphinx,
  unidecode,
  versioneer,
}:

buildPythonPackage rec {
  pname = "sphinx-material";
  version = "0.0.36";
  pyproject = true;

  src = fetchPypi {
    pname = "sphinx_material";
    inherit version;
    hash = "sha256-7v9ffT3AFq8yuv33DGbmcdFch1Tb4GE9+9Yp++2RKGk=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    sphinx
    beautifulsoup4
    python-slugify
    unidecode
    css-html-js-minify
    lxml
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sphinx_material" ];

  meta = {
    description = "Material-based, responsive theme inspired by mkdocs-material";
    homepage = "https://bashtage.github.io/sphinx-material";
    changelog = "https://github.com/bashtage/sphinx-material/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
}
