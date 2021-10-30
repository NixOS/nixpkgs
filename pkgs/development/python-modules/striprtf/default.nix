{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "striprtf";
  version = "0.0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yvgnmds034z28mscff0amm0g47ni0753nshvrq2swdpipymiwz0";
  };

  meta = with lib; {
    homepage = "https://github.com/joshy/striprtf";
    description = "A simple library to convert rtf to text";
    maintainers = with maintainers; [ aanderse ];
    license = with licenses; [ bsd3 ];
  };
}
