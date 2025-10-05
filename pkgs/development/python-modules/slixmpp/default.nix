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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "slixmpp";
  version = "1.11.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hQxfOxlkpQdCWlGSdotZY6eHkJr6M3xkkRv4bR0urPM=";
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
    hash = "sha256-z0X9s36n1p31boxoe6Er0Ieirinaehoucsi89oDAS0c=";
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

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

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
