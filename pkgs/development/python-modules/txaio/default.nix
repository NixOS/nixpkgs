{ stdenv, buildPythonPackage, fetchPypi, pytest, mock, six, twisted }:

buildPythonPackage rec {
  pname = "txaio";
  version = "2.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dfc3a7d04b4b484ae5ff241affab5bb01306b1e950dd6f54fd036cfca94345d0";
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
    platforms   = platforms.all;
  };
}
