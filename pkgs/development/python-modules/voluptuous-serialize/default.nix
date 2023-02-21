{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, voluptuous
}:

buildPythonPackage rec  {
  pname = "voluptuous-serialize";
  version = "2.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-vvreXSQDkA3JkZpOKZqJgMRyObJX/cSR8r+A26h9fNE=";
  };

  propagatedBuildInputs = [
    voluptuous
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "voluptuous_serialize"
  ];

  meta = with lib; {
    description = "Convert Voluptuous schemas to dictionaries so they can be serialized";
    homepage = "https://github.com/home-assistant-libs/voluptuous-serialize";
    changelog = "https://github.com/home-assistant-libs/voluptuous-serialize/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
