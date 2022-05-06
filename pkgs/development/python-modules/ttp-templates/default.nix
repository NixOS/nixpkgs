{ lib
, buildPythonPackage
, fetchFromGitHub
, netmiko
, pytestCheckHook
, python
, pythonOlder
, ttp
}:

buildPythonPackage rec {
  pname = "ttp-templates";
  version = "0.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dmulyalin";
    repo = "ttp_templates";
    rev = version;
    hash = "sha256-Qx+z/srYgD67FjXzYrc8xtA99n8shWK7yWj/r/ETN2U=";
  };

  propagatedBuildInputs = [
    ttp
  ];

  checkInputs = [
    netmiko
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ttp_templates"
  ];

  pytestFlagsArray = [
    # The other tests requires data which is no part of the source
    "test/test_ttp_templates_methods.py"
    "test/test_yang_openconfig_lldp.py"
  ];

  meta = with lib; {
    description = "Template Text Parser Templates collections";
    homepage = "https://github.com/dmulyalin/ttp_templates";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
