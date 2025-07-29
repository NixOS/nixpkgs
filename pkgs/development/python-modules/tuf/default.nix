{
  lib,
  buildPythonPackage,
  ed25519,
  freezegun,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  flit-core,
  requests,
  securesystemslib,
}:

buildPythonPackage rec {
  pname = "tuf";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theupdateframework";
    repo = "python-tuf";
    tag = "v${version}";
    hash = "sha256-CPbZOpUYi7MWKLMj7kwTsmEkxLCf4wU7IOCcbzMkPlU=";
  };

  build-system = [
    flit-core
    hatchling
  ];

  dependencies = [
    requests
    securesystemslib
  ]
  ++ securesystemslib.optional-dependencies.pynacl
  ++ securesystemslib.optional-dependencies.crypto;

  __darwinAllowLocalNetworking = true;

  checkInputs = [
    freezegun
  ];

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
