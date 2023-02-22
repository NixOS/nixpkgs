{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
, pydata-sphinx-theme
, pyyaml
, jupyter-book
}:

buildPythonPackage rec {
  pname = "sphinx-book-theme";
  version = "1.0.0rc2";

  format = "wheel";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version format;
    dist = "py3";
    python = "py3";
    pname = "sphinx_book_theme";
    sha256 = "43977402f55b79706e117c6de6f50e67dac6dad698eb9b75be07dc2e6a689bde";
  };

  propagatedBuildInputs = [
    sphinx
    pydata-sphinx-theme
    pyyaml
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
