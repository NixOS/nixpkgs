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
  version = "0.0.35";

  src = fetchPypi {
    pname = "sphinx_material";
    inherit version;
    sha256 = "27f0f1084aa0201b43879aef24a0521b78dc8df4942b003a4e7d79ab11515852";
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
