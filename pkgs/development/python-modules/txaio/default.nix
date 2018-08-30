{ stdenv, buildPythonPackage, fetchPypi, pytest, mock, six, twisted }:

buildPythonPackage rec {
  pname = "txaio";
  version = "18.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "701de939e90bb80f7e085357081552437526752199def5541dddfc34c0b0593f";
  };

  checkInputs = [ pytest mock ];

  propagatedBuildInputs = [ six twisted ];

  checkPhase = ''
    py.test -k "not test_sdist"
  '';

  meta = with stdenv.lib; {
    description = "Utilities to support code that runs unmodified on Twisted and asyncio.";
    homepage    = "https://github.com/crossbario/txaio";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
