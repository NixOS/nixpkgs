{ lib
, buildPythonPackage
, aiodns
, aiohttp
, fetchPypi
, gnupg
, isPy3k
, pyasn1
, pyasn1-modules
, pytestCheckHook
, substituteAll
}:

buildPythonPackage rec {
  pname = "slixmpp";
  version = "1.7.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mvg23FdHJZeIZRcm8GLWmm9DDTBt29jmsUHB/smVSec=";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-gnupg-path.patch;
      inherit gnupg;
    })
  ];

  propagatedBuildInputs = [
    aiodns
    aiohttp
    pyasn1
    pyasn1-modules
  ];

  checkInputs = [ pytestCheckHook ];

  # Exclude live tests
  disabledTestPaths = [ "tests/live_test.py" ];

  pythonImportsCheck = [ "slixmpp" ];

  meta = with lib; {
    description = "Elegant Python library for XMPP";
    homepage = "https://slixmpp.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
