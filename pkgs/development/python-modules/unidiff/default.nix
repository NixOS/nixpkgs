{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "unidiff";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00fa7b9f36460da0bd0332750eda494cb5146d71bdc8c1dc759c460b52a94fd5";
  };

  pythonImportsCheck = [ "unidiff" ];

  meta = with lib; {
    description = "Unified diff python parsing/metadata extraction library";
    homepage = "https://github.com/matiasb/python-unidiff";
    changelog = "https://github.com/matiasb/python-unidiff/raw/v${version}/HISTORY";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
