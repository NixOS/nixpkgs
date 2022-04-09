{ lib
, buildPythonPackage
, aiodns
, aiohttp
, fetchPypi
, gnupg
, pyasn1
, pyasn1-modules
, pytestCheckHook
, substituteAll
, pythonOlder
}:

buildPythonPackage rec {
  pname = "slixmpp";
  version = "1.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QgTIC+4JtAD9nnS+fJKZwF0aJEIrFmPHkYg8cPgXmcA=";
  };

  propagatedBuildInputs = [
    aiodns
    aiohttp
    pyasn1
    pyasn1-modules
  ];

  checkInputs = [
    pytestCheckHook
  ];

  patches = [
    (substituteAll {
      src = ./hardcode-gnupg-path.patch;
      inherit gnupg;
    })
  ];

  disabledTestPaths = [
    # Exclude live tests
    "tests/live_test.py"
  ];

  pythonImportsCheck = [
    "slixmpp"
  ];

  meta = with lib; {
    description = "Python library for XMPP";
    homepage = "https://slixmpp.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
