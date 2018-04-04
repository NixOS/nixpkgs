{ lib, buildPythonPackage, fetchPypi, python, mock }:

buildPythonPackage rec {
  pname = "stem";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1va9p3ij7lxg6ixfsvaql06dn11l3fgpxmss1dhlvafm7sqizznp";
  };

  postPatch = ''
    rm test/unit/installation.py
    sed -i "/test.unit.installation/d" test/settings.cfg
  '';

  checkInputs = [ mock ];

  checkPhase = ''
    touch .gitignore
    ${python.interpreter} run_tests.py -u
  '';

  meta = with lib; {
    description = "Controller library that allows applications to interact with Tor";
    homepage = https://stem.torproject.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ phreedom ];
  };
}
