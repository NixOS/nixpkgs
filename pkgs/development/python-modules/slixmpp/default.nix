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
  pyasn1,
  pyasn1-modules,
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
  version = "1.16.0";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "poezio";
    repo = "slixmpp";
    tag = "slix-${finalAttrs.version}";
    hash = "sha256-d0laQWaqZUoviF7NM/egENQ3ArQE12ER0TzfPBcnc7Q=";
  };

  patches = [
    (replaceVars ./hardcode-gnupg-path.patch {
      inherit gnupg;
    })
  ];

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

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

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  dependencies = [
    aiodns
    pyasn1
    pyasn1-modules
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

  preCheck = ''
    # don't test against pure python version in the source tree
    rm -rf slixmpp
  '';

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
    maintainers = with lib.maintainers; [ fab ];
  };
})
