{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  hatchling,
  pytestCheckHook,
  requests,
  securesystemslib,
}:

buildPythonPackage (finalAttrs: {
  pname = "tuf";
  version = "7.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theupdateframework";
    repo = "python-tuf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pn1M3e3Vzu2CYp/3KXkreaHunr+Nblph0QBWAkTmrIE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.29.0" "hatchling"
  '';

  build-system = [ hatchling ];

  dependencies = [
    requests
    securesystemslib
  ]
  ++ securesystemslib.optional-dependencies.pynacl
  ++ securesystemslib.optional-dependencies.crypto;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tuf" ];

  preCheck = ''
    cd tests
  '';

  meta = {
    description = "Python reference implementation of The Update Framework (TUF)";
    homepage = "https://github.com/theupdateframework/python-tuf";
    changelog = "https://github.com/theupdateframework/python-tuf/blob/${finalAttrs.src.tag}/docs/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
