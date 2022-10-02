{ lib
, buildPythonPackage
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-multitoc-numbering";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c9607671ac511236fa5d61a7491c1031e700e8d498c9d2418e6c61d1251209ae";
  };

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinx_multitoc_numbering" ];

  meta = with lib; {
    description = "Supporting continuous HTML section numbering";
    homepage = "https://github.com/executablebooks/sphinx-multitoc-numbering";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
