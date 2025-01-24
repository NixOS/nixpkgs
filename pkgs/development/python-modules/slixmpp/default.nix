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
  substituteAll,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "slixmpp";
  version = "1.8.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dePwrUhVX39ckijnBmwdQ1izPWQLT753PsNLA7f66aM=";
  };

  propagatedBuildInputs = [
    aiodns
    aiohttp
    pyasn1
    pyasn1-modules
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  patches = [
    (substituteAll {
      src = ./hardcode-gnupg-path.patch;
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
