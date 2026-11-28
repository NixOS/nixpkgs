{
  lib,
  buildPythonPackage,
  aiodns,
  aiohttp,
  cargo,
  cryptography,
  defusedxml,
  emoji,
  fetchFromCodeberg,
  gnupg,
  pytestCheckHook,
  replaceVars,
  rustc,
  rustPlatform,
  setuptools,
  setuptools-rust,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "slixmpp";
  version = "1.18.0";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "poezio";
    repo = "slixmpp";
    tag = "slix-${finalAttrs.version}";
    hash = "sha256-/o0l7JqR+mXXjF4MaHE+1H0CQG2Sd2bpVOGtquZZzlc=";
  };

  patches = [
    (replaceVars ./hardcode-gnupg-path.patch {
      inherit gnupg;
    })
  ];

  build-system = [
    setuptools
    setuptools-rust
    setuptools-scm
  ];

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-E9KwkT6LVeRDSL8BuvGcjHPRhO+Uz6Vz75MlFWYnSpQ=";
  };

  dependencies = [
    aiodns
  ];

  optional-dependencies = {
    xep-0363 = [ aiohttp ];
    xep-0444-compliance = [ emoji ];
    xep-0454 = [ cryptography ];
    safer-xml-parsing = [ defusedxml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTestPaths = [
    # Exclude integration tests
    "itests/"
    # Exclude live tests
    "tests/live_test.py"
  ];

  pythonImportsCheck = [ "slixmpp" ];

  meta = {
    description = "Python library for XMPP";
    homepage = "https://slixmpp.readthedocs.io/";
    changelog = "https://codeberg.org/poezio/slixmpp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "slixmpp_project" finalAttrs.version;
    maintainers = with lib.maintainers; [
      fab
      haansn08
    ];
  };
})
