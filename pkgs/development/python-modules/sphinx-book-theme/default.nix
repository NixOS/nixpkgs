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
  version = "0.3.3";

  format = "wheel";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version format;
    dist = "py3";
    python = "py3";
    pname = "sphinx_book_theme";
    sha256 = "9685959dbbb492af005165ef1b9229fdd5d5431580ac181578beae3b4d012d91";
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
