{ stdenv, buildPythonPackage, fetchPypi, pytest, mock, six, twisted }:

buildPythonPackage rec {
  pname = "txaio";
  version = "2.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4797f9f6a9866fe887c96abc0110a226dd5744c894dc3630870542597ad30853";
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
