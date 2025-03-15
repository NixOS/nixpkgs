{
  lib,
  buildPythonPackage,
  ed25519,
  fetchFromGitHub,
  hatchling,
  pytest-freezegun,
  pytestCheckHook,
  pythonOlder,
  requests,
  securesystemslib,
}:

buildPythonPackage rec {
  pname = "tuf";
  version = "6.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "theupdateframework";
    repo = "python-tuf";
    tag = "v${version}";
    hash = "sha256-CPbZOpUYi7MWKLMj7kwTsmEkxLCf4wU7IOCcbzMkPlU=";
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
    pytest-freezegun
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
