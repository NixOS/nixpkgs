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
  version = "0.0.32";

  src = fetchPypi {
    pname = "sphinx_material";
    inherit version;
    sha256 = "ec02825a1bbe8b662fe624c11b87f1cd8d40875439b5b18c38649cf3366201fa";
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
