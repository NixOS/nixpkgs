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
<<<<<<< HEAD
  version = "1.8.4";
=======
  version = "1.8.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-QG8fS6t+dXPdVZpEECfT3jPRe7o1S88g3caq+6JyKGs=";
=======
    hash = "sha256-rJtZqq7tZ/VFk4fMpDZYyTQRa1Pokmn2aw6LA+FBGXw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiodns
    aiohttp
    pyasn1
    pyasn1-modules
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  patches = [
    (substituteAll {
      src = ./hardcode-gnupg-path.patch;
      inherit gnupg;
    })
<<<<<<< HEAD
=======
    # Upstream MR: https://lab.louiz.org/poezio/slixmpp/-/merge_requests/198
    ./0001-xep_0030-allow-extra-args-in-get_info_from_domain.patch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://lab.louiz.org/poezio/slixmpp/-/tags/slix-${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
