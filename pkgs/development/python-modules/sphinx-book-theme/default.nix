{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  sphinx,
  pydata-sphinx-theme,
  jupyter-book,
}:

buildPythonPackage rec {
  pname = "sphinx-book-theme";
  version = "1.1.3";

  format = "wheel";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version format;
    dist = "py3";
    python = "py3";
    pname = "sphinx_book_theme";
    hash = "sha256-pVSpp6w4gZeah6KxD2M6oqVwbnIhihD3G+OLPJ6DGuk=";
  };

  propagatedBuildInputs = [
    pydata-sphinx-theme
    sphinx
  ];

  pythonImportsCheck = [ "sphinx_book_theme" ];

  passthru.tests = {
    inherit jupyter-book;
  };

  meta = with lib; {
    description = "Clean book theme for scientific explanations and documentation with Sphinx";
    homepage = "https://github.com/executablebooks/sphinx-book-theme";
    changelog = "https://github.com/executablebooks/sphinx-book-theme/raw/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
