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
  version = "5.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "theupdateframework";
    repo = "python-tuf";
    rev = "refs/tags/v${version}";
    hash = "sha256-Qv9SH4ObC7bgPLd2Wu5XynBddlW6pycwLwaKhZ+l61k=";
  };

  build-system = [ hatchling ];

  dependencies =
    [
      requests
      securesystemslib
    ]
    ++ securesystemslib.optional-dependencies.pynacl
    ++ securesystemslib.optional-dependencies.crypto;

  nativeCheckInputs = [
    ed25519
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tuf" ];

  preCheck = ''
    cd tests
  '';

  meta = {
    description = "Python reference implementation of The Update Framework (TUF)";
    homepage = "https://github.com/theupdateframework/python-tuf";
    changelog = "https://github.com/theupdateframework/python-tuf/blob/v${version}/docs/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
