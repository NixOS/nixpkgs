{
  lib,
  buildPythonPackage,
  eth-hash,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "validators";
  version = "0.35.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-validators";
    repo = "validators";
    tag = version;
    hash = "sha256-b3kjKbqmfny6YnU0rlrralTgvYT06sUpckI4EDKDleA=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    crypto-eth-addresses = [ eth-hash ] ++ eth-hash.optional-dependencies.pycryptodome;
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "validators" ];

  meta = with lib; {
    description = "Python Data Validation for Humans";
    homepage = "https://github.com/python-validators/validators";
    changelog = "https://github.com/python-validators/validators/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
