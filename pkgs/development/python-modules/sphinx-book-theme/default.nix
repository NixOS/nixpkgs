{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
, pydata-sphinx-theme
, pyyaml
}:

buildPythonPackage rec {
  pname = "sphinx-book-theme";
  version = "0.3.2";

  format = "wheel";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version format;
    dist = "py3";
    python = "py3";
    pname = "sphinx_book_theme";
    sha256 = "4aed92f2ed9d27e002eac5dce1daa8eca42dd9e6464811533c569ee156a6f67d";
  };

  propagatedBuildInputs = [
    sphinx
    pydata-sphinx-theme
    pyyaml
  ];

  pythonImportsCheck = [ "sphinx_book_theme" ];

  meta = with lib; {
    description = "A clean book theme for scientific explanations and documentation with Sphinx";
    homepage = "https://github.com/executablebooks/sphinx-book-theme";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
