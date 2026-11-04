{
  lib,
  buildPythonPackage,
  eth-hash,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "validators";
  version = "0.36.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-validators";
    repo = "validators";
    tag = version;
    hash = "sha256-uQ2jJJRljMegFZqPZZSffvKkgabxD0wwQXe1d1i5HtE=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    crypto-eth-addresses = [ eth-hash ] ++ eth-hash.optional-dependencies.pycryptodome;
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "validators" ];

  meta = {
    description = "Python Data Validation for Humans";
    homepage = "https://github.com/python-validators/validators";
    changelog = "https://github.com/python-validators/validators/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
