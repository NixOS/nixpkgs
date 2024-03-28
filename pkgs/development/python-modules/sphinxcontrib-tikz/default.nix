{ lib
, buildPythonPackage
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-tikz";
  version = "0.4.16";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8f9FNx6WMopcqihUzNlQoPBGYoW2YkFi6W1iaFLD4qU=";
  };

  propagatedBuildInputs = [ sphinx ];

  # no tests in package
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.tikz" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "TikZ extension for Sphinx";
    homepage = "https://bitbucket.org/philexander/tikz";
    maintainers = with maintainers; [ ];
    license = licenses.bsd3;
  };

}
