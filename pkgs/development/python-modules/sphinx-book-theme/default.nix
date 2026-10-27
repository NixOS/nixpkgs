{
  lib,
  buildPythonPackage,
  fetchPypi,
  sphinx,
  pydata-sphinx-theme,
  jupyter-book,
}:

buildPythonPackage rec {
  pname = "sphinx-book-theme";
  version = "1.4.0";

  format = "wheel";

  src = fetchPypi {
    inherit version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    pname = "sphinx_book_theme";
    hash = "sha256-EP1X1mfuC1ZZKMPOlVYuKBxdG5S9Wiqvxc1BpdSY3NA=";
  };

  dependencies = [
    pydata-sphinx-theme
    sphinx
  ];

  pythonImportsCheck = [ "sphinx_book_theme" ];

  passthru.tests = {
    inherit jupyter-book;
  };

  meta = {
    description = "Clean book theme for scientific explanations and documentation with Sphinx";
    homepage = "https://github.com/executablebooks/sphinx-book-theme";
    changelog = "https://github.com/executablebooks/sphinx-book-theme/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
