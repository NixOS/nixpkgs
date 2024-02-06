{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
, pydata-sphinx-theme
, jupyter-book
}:

buildPythonPackage rec {
  pname = "sphinx-book-theme";
  version = "1.1.0";

  format = "wheel";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version format;
    dist = "py3";
    python = "py3";
    pname = "sphinx_book_theme";
    hash = "sha256-CIvGnWX6uERq24aR7WFof3G/dQTJdAr2i8eM+TaiYRI=";
  };

  propagatedBuildInputs = [
    pydata-sphinx-theme
    sphinx
  ];

  pythonImportsCheck = [
    "sphinx_book_theme"
  ];

  passthru.tests = {
    inherit jupyter-book;
  };

  meta = with lib; {
    description = "A clean book theme for scientific explanations and documentation with Sphinx";
    homepage = "https://github.com/executablebooks/sphinx-book-theme";
    changelog = "https://github.com/executablebooks/sphinx-book-theme/raw/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
