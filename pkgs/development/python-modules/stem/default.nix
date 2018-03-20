{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "stem";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1va9p3ij7lxg6ixfsvaql06dn11l3fgpxmss1dhlvafm7sqizznp";
  };

  meta = with lib; {
    description = "Controller library that allows applications to interact with Tor";
    homepage = https://stem.torproject.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ phreedom ];
  };
}
