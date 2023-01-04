{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, sphinxcontrib-tikz
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-bayesnet";
  version = "0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+M+K8WzQqxQUGgAgGPK+isf3gKK7HOrdI6nNW/V8Wv0=";
  };

  propagatedBuildInputs = [
    sphinx
    sphinxcontrib-tikz
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "sphinxcontrib.bayesnet"
  ];

  meta = with lib; {
    description = "Bayesian networks and factor graphs in Sphinx using TikZ syntax";
    homepage = "https://github.com/jluttine/sphinx-bayesnet";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jluttine ];
  };
}
