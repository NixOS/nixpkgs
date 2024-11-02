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
  version = "0.34.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-validators";
    repo = "validators";
    rev = "refs/tags/${version}";
    hash = "sha256-1QKo6nidaHeKCbti/xALbgylHYbtBUJlWrjhNtdx8kU=";
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
