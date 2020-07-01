{ stdenv, buildPythonPackage, fetchPypi, pytest, mock, six, twisted, isPy37, isPy27 }:

buildPythonPackage rec {
  pname = "txaio";
  version = "20.4.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "17938f2bca4a9cabce61346758e482ca4e600160cbc28e861493eac74a19539d";
  };

  checkInputs = [ pytest mock ];

  propagatedBuildInputs = [ six twisted ];

  checkPhase = ''
    py.test -k "not test_sdist"
  '';

  # Needs some fixing
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Utilities to support code that runs unmodified on Twisted and asyncio.";
    homepage    = "https://github.com/crossbario/txaio";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
