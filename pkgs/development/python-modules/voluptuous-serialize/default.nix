{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pytestCheckHook
, voluptuous
}:

buildPythonPackage rec  {
  pname = "voluptuous-serialize";
  version = "2.6.0";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "voluptuous-serialize";
    rev = "refs/tags/${version}";
    hash = "sha256-vvreXSQDkA3JkZpOKZqJgMRyObJX/cSR8r+A26h9fNE=";
  };

  propagatedBuildInputs = [
    voluptuous
  ];

  nativeCheckInputs = [
    pytestCheckHook
    voluptuous
  ];

  pythonImportsCheck = [
    "voluptuous_serialize"
  ];

  meta = with lib; {
    homepage = "https://github.com/home-assistant-libs/voluptuous-serialize";
    license = licenses.asl20;
    description = "Convert Voluptuous schemas to dictionaries so they can be serialized";
    maintainers = with maintainers; [ ];
  };
}
