{ lib
<<<<<<< HEAD
, beautifulsoup4
, buildPythonPackage
, css-html-js-minify
, fetchPypi
, lxml
, python-slugify
, pythonOlder
, sphinx
, unidecode
=======
, buildPythonPackage
, fetchPypi
, sphinx
, beautifulsoup4
, python-slugify
, unidecode
, css-html-js-minify
, lxml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "sphinx-material";
<<<<<<< HEAD
  version = "0.0.36";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.0.35";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    pname = "sphinx_material";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-7v9ffT3AFq8yuv33DGbmcdFch1Tb4GE9+9Yp++2RKGk=";
=======
    sha256 = "27f0f1084aa0201b43879aef24a0521b78dc8df4942b003a4e7d79ab11515852";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    sphinx
    beautifulsoup4
    python-slugify
    unidecode
    css-html-js-minify
    lxml
  ];

  doCheck = false; # no tests

<<<<<<< HEAD
  pythonImportsCheck = [
    "sphinx_material"
  ];
=======
  pythonImportsCheck = [ "sphinx_material" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A material-based, responsive theme inspired by mkdocs-material";
    homepage = "https://bashtage.github.io/sphinx-material";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
