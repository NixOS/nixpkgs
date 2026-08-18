{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  simplejson,
  jsonschema,
  pyfakefs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "validator-collection";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "insightindustry";
    repo = "validator-collection";
    tag = "v.${version}";
    hash = "sha256-CDPfIkZZRpl1rAzNpLKJfaBEGWUl71coic2jOHIgi6o=";
  };

  build-system = [ setuptools ];

  # listed in setup.py, the requirements.txt is _full_ of dev junk
  dependencies = [
    jsonschema
    simplejson # optional but preferred
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyfakefs
  ];

  pythonImportsCheck = [ "validator_collection" ];

  disabledTests = [
    # Issues with fake filesystem /var/data
    "test_writeable"
    "test_executable"
    "test_readable"
    "test_is_readable"
  ];

  meta = {
    description = "Python library of 60+ commonly-used validator functions";
    homepage = "https://github.com/insightindustry/validator-collection/";
    changelog = "https://github.com/insightindustry/validator-collection/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
