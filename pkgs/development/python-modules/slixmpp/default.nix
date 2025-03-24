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
  version = "1.8.6";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YK/Kp8laD7nn8RWctwRkpVWIBterrinNMeP8iD+biws=";
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
