{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  python-dateutil,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "srpenergy";
  version = "1.3.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "lamoreauxlab";
    repo = "srpenergy-api-client-python";
    tag = version;
    hash = "sha256-bdBF5y9hRj4rceUD5qjHOM9TIaHGElJ36YjWCJgCzX8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==" "setuptools>="
  '';

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "srpenergy.client" ];

  meta = with lib; {
    changelog = "https://github.com/lamoreauxlab/srpenergy-api-client-python/releases/tag/${version}";
    description = "Unofficial Python module for interacting with Srp Energy data";
    homepage = "https://github.com/lamoreauxlab/srpenergy-api-client-python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
