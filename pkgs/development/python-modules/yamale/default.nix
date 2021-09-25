{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pyyaml
, ruamel_yaml
}:

buildPythonPackage rec {
  pname = "yamale";
  version = "3.0.8";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "23andMe";
    repo = pname;
    rev = version;
    sha256 = "0bn0himn5fwndaxn205s55bdc4np7lhd940i0lkv0m7ybhbw7dap";
  };

  propagatedBuildInputs = [
    pyyaml
    ruamel_yaml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "yamale" ];

  meta = with lib; {
    description = "A schema and validator for YAML";
    homepage = "https://github.com/23andMe/Yamale";
    license = licenses.mit;
    maintainers = with maintainers; [ rtburns-jpl ];
  };
}
