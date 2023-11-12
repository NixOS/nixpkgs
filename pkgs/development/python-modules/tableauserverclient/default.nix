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
  version = "0.28";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jSblDVkuuBBZ7GmPKUYji8wtRoPS7g8r6Ye9EpnjvKA=";
  };

  propagatedBuildInputs = [ defusedxml requests packaging ];

  checkInputs = [ requests-mock ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = false; # it attempts to create some file artifacts and fails

  meta = with lib; {
    description = "Module for working with the Tableau Server REST API";
    homepage = "https://github.com/tableau/server-client-python";
    changelog = "https://github.com/tableau/server-client-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
