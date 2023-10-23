{ lib
, buildPythonPackage
, python
, fetchPypi
, defusedxml
, requests
, packaging
, requests-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tableauserverclient";
  version = "0.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vn7A7n0Z4kTtrm8MEoUJiv94K3qA/4Kx8lElhDM/LlI=";
  };

  propagatedBuildInputs = [ defusedxml requests packaging ];

  checkInputs = [ requests-mock ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = false; # it attempts to create some file artifacts and fails

  meta = {
    description = "A Python module for working with the Tableau Server REST API.";
    homepage = "https://pypi.org/project/tableauserverclient/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
