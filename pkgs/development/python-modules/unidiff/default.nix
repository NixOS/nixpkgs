{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "unidiff";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "91bb13b4969514a400679d9ae5e29a6ffad85346087677f8b5e2e036af817447";
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
