{
  lib,
  buildPythonPackage,
  ed25519,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pythonOlder,
  requests,
  securesystemslib,
}:

buildPythonPackage rec {
  pname = "tuf";
  version = "5.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "theupdateframework";
    repo = "python-tuf";
    rev = "refs/tags/v${version}";
    hash = "sha256-dzFnPfZ5uT+o7efDTpDpXZI+jWg/pvXCReuLQH/oOxQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    securesystemslib
  ] ++ securesystemslib.optional-dependencies.pynacl ++ securesystemslib.optional-dependencies.crypto;

  nativeCheckInputs = [
    ed25519
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tuf" ];

  preCheck = ''
    cd tests
  '';

  meta = with lib; {
    description = "Python reference implementation of The Update Framework (TUF)";
    homepage = "https://github.com/theupdateframework/python-tuf";
    changelog = "https://github.com/theupdateframework/python-tuf/blob/v${version}/docs/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ fab ];
  };
}
