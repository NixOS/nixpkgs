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
  version = "1.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U7lD2iVy2gS5Ktop4PVKg+cUbIg4MJt+m6tH5aOb1Y4=";
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
    # Upstream MR: https://lab.louiz.org/poezio/slixmpp/-/merge_requests/198
    ./0001-xep_0030-allow-extra-args-in-get_info_from_domain.patch
  ];

  disabledTestPaths = [
    # Exclude live tests
    "tests/live_test.py"
    "tests/test_xep_0454.py"
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
