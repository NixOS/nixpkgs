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
}:

buildPythonPackage rec {
  pname = "spdx-tools";
  version = "0.7.0a3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-afV1W1n5ubHhqfLFpPO5fxaIy5TaZdw9eDy3JYOJ1oE=";
  };

  propagatedBuildInputs = [
    click
    ply
    pyyaml
    rdflib
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
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
