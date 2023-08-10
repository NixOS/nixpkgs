{ lib
, buildPythonPackage
, beartype
, click
, fetchPypi
, license-expression
, pyyaml
, rdflib
, ply
, semantic-version
, xmltodict
, pytestCheckHook
, pythonOlder
, uritools
}:

buildPythonPackage rec {
  pname = "spdx-tools";
  version = "0.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZoCb94eDtHFH3K9ppju51WHrReay7BXC6P4VUOJK4c0=";
  };

  propagatedBuildInputs = [
    beartype
    click
    license-expression
    ply
    pyyaml
    rdflib
    semantic-version
    uritools
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "spdx_tools.spdx"
  ];

  disabledTestPaths = [
    # Depends on the currently not packaged pyshacl module.
    "tests/spdx3/validation/json_ld/test_shacl_validation.py"
  ];

  meta = with lib; {
    description = "SPDX parser and tools";
    homepage = "https://github.com/spdx/tools-python";
    changelog = "https://github.com/spdx/tools-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
