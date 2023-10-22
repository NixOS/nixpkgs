{ lib, buildPythonPackage, fetchPypi, python, mock }:

buildPythonPackage rec {
  pname = "stem";
  version = "1.8.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g/sZ/9TJ+CIHwAYFFIA4n4CvIhp+R4MACu3sTjhOtYI=";
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
