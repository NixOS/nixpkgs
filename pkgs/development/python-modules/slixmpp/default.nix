{
  lib,
  buildPythonPackage,
  aiodns,
  aiohttp,
  fetchPypi,
  gnupg,
  pyasn1,
  pyasn1-modules,
  pytestCheckHook,
  replaceVars,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "slixmpp";
  version = "1.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RrxdAVB8tChcglXOXHF8C19o5U38HxcSiDmY1tciV4o=";
  };

  propagatedBuildInputs = [
    aiodns
    aiohttp
    pyasn1
    pyasn1-modules
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  patches = [
    (replaceVars ./hardcode-gnupg-path.patch {
      inherit gnupg;
    })
  ];

  disabledTestPaths = [
    # Exclude live tests
    "tests/live_test.py"
    "tests/test_xep_0454.py"
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
