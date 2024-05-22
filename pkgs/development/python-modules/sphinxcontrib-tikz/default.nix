{ lib
, buildPythonPackage
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-tikz";
  version = "0.4.19";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gen+bH4NvEbxnxr5HStisB1BqyKIS4n1VoHyAK4mXUk=";
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
