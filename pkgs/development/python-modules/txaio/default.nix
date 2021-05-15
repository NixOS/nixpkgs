{ lib, buildPythonPackage, fetchPypi, pytest, mock, six, twisted, isPy37, isPy27 }:

buildPythonPackage rec {
  pname = "txaio";
  version = "21.2.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d6f89745680233f1c4db9ddb748df5e88d2a7a37962be174c0fd04c8dba1dc8";
  };

  checkInputs = [ pytest mock ];

  propagatedBuildInputs = [ six twisted ];

  checkPhase = ''
    py.test -k "not test_sdist"
  '';

  # Needs some fixing
  doCheck = false;

  meta = with lib; {
    description = "Utilities to support code that runs unmodified on Twisted and asyncio.";
    homepage    = "https://github.com/crossbario/txaio";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
