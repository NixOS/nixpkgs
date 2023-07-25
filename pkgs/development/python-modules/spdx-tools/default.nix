{ lib
, buildPythonPackage
, click
, fetchPypi
, pyyaml
, rdflib
, ply
, xmltodict
, pytestCheckHook
, pythonOlder
, uritools
}:

buildPythonPackage rec {
  pname = "spdx-tools";
  version = "0.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l15tu6iPEFqKyyKr9T/pDw6dVjWiubH+SHeB6WliOxc=";
  };

  propagatedBuildInputs = [
    click
    ply
    pyyaml
    rdflib
    uritools
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "spdx"
  ];

  meta = with lib; {
    description = "SPDX parser and tools";
    homepage = "https://github.com/spdx/tools-python";
    changelog = "https://github.com/spdx/tools-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
