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
  version = "0.4.0rc1";

  format = "wheel";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version format;
    dist = "py3";
    python = "py3";
    pname = "sphinx_book_theme";
    sha256 = "bfad8ef469885da5633f7cf7f8cd9a0ae11ea2351a91e507b44cf15973934512";
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
    changelog = "https://github.com/executablebooks/sphinx-book-theme/raw/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
