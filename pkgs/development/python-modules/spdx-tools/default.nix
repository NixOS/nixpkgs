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
  version = "0.7.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QqKMKBedWOFYF1av9IgQuyJ6b5mNhhMpIZVJdEDcAK8=";
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
