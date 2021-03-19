{ lib, buildPythonPackage, fetchPypi, pytest, mock, six, twisted, isPy37, isPy27 }:

buildPythonPackage rec {
  pname = "txaio";
  version = "21.2.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1j0xpa6lrl0g9hbvwqkrlfkx522yvx4bgpdr9lf3y8w0ars8jvvx";
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
