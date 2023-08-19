{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, beautifulsoup4
, python-slugify
, unidecode
, css-html-js-minify
, lxml
}:

buildPythonPackage rec {
  pname = "sphinx-material";
  version = "0.0.36";

  src = fetchPypi {
    pname = "sphinx_material";
    inherit version;
    sha256 = "sha256-7v9ffT3AFq8yuv33DGbmcdFch1Tb4GE9+9Yp++2RKGk=";
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

  pythonImportsCheck = [ "sphinx_material" ];

  meta = with lib; {
    description = "A material-based, responsive theme inspired by mkdocs-material";
    homepage = "https://bashtage.github.io/sphinx-material";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
