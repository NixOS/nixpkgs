{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pbr
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "ssdp";
  version = "1.1.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d33575a7360aaead5341cc2ceaf47cc80b2309a7dd167c2ea45d5a5b00851665";
  };

  buildInputs = [ pbr ];
  checkInputs = [ pytest ];

  # test suite uses new async primitives
  doCheck = !isPy27;

  meta = with lib; {
    homepage = "https://github.com/codingjoe/ssdp";
    description = "Python asyncio library for Simple Service Discovery Protocol (SSDP).";
    license = licenses.mit;
  };
}
