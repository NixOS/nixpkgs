{ lib, buildPythonPackage, fetchPypi, python, mock }:

buildPythonPackage rec {
  pname = "stem";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gdQ6fGaLqde8EQOy56kR6dFIKUs3PSelmujaee96Pi8=";
  };

  postPatch = ''
    rm test/unit/installation.py
    sed -i "/test.unit.installation/d" test/settings.cfg
    # https://github.com/torproject/stem/issues/56
    sed -i '/MOCK_VERSION/d' run_tests.py
  '';

  nativeCheckInputs = [ mock ];

  checkPhase = ''
    touch .gitignore
    ${python.interpreter} run_tests.py -u
  '';

  meta = with lib; {
    description = "Controller library that allows applications to interact with Tor";
    homepage = "https://stem.torproject.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}
