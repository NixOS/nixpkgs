{ stdenv, buildPythonPackage, fetchPypi, pytest, mock, six, twisted,isPy37 }:

buildPythonPackage rec {
  pname = "txaio";
  version = "18.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "67e360ac73b12c52058219bb5f8b3ed4105d2636707a36a7cdafb56fe06db7fe";
  };

  checkInputs = [ pytest mock ];

  propagatedBuildInputs = [ six twisted ];

  checkPhase = ''
    py.test -k "not test_sdist"
  '';

  # Needs some fixing for 3.7
  doCheck = !isPy37;

  meta = with stdenv.lib; {
    description = "Utilities to support code that runs unmodified on Twisted and asyncio.";
    homepage    = "https://github.com/crossbario/txaio";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
