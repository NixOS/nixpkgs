{
  lib,
  buildPythonPackage,
  aiodns,
  aiohttp,
  cryptography,
  defusedxml,
  emoji,
  fetchPypi,
  gnupg,
  pyasn1,
  pyasn1-modules,
  pytestCheckHook,
  replaceVars,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "slixmpp";
  version = "1.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dGn23K9XQv1i4OZu5EfFM4p0UgwZgqcHhOe3kN7y/dU=";
  };

  patches = [
    (replaceVars ./hardcode-gnupg-path.patch {
      inherit gnupg;
    })
  ];

  build-system = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src;
    hash = "sha256-eKXQeZ2RLHsTZmYszws4fCHgeiSO9wsrRbPkVV1gqZY=";
  };

  dependencies = [
    aiodns
    pyasn1
    pyasn1-modules
  ];

  optional-dependencies = {
    xep-0363 = [ aiohttp ];
    xep-0444-compliance = [ emoji ];
    xep-0464 = [ cryptography ];
    safer-xml-parserig = [ defusedxml ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;

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

  meta = with lib; {
    description = "Python library for XMPP";
    homepage = "https://slixmpp.readthedocs.io/";
    changelog = "https://codeberg.org/poezio/slixmpp/releases/tag/slix-${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
