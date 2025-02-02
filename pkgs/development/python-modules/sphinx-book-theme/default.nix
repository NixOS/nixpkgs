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
  version = "1.1.2";

  format = "wheel";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version format;
    dist = "py3";
    python = "py3";
    pname = "sphinx_book_theme";
    hash = "sha256-zudERm/eSPUDArhRKRsgiqZ+cmyjG3o7+5tuahRWY+A=";
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
    description = "A clean book theme for scientific explanations and documentation with Sphinx";
    homepage = "https://github.com/executablebooks/sphinx-book-theme";
    changelog = "https://github.com/executablebooks/sphinx-book-theme/raw/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
