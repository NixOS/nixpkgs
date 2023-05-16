{ lib, buildPythonPackage, fetchPypi, python, mock, pythonAtLeast }:

buildPythonPackage rec {
  pname = "stem";
<<<<<<< HEAD
  version = "1.8.2";
=======
  version = "1.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # As of May 2023, the master branch of stem contains fixes for Python 3.11
  # that the last release (1.8.1) doesn't. The test suite fails on both master
  # and the 1.8.1 release, so disabling rather than switching to an unstable
  # source.
  disabled = pythonAtLeast "3.11";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-g/sZ/9TJ+CIHwAYFFIA4n4CvIhp+R4MACu3sTjhOtYI=";
=======
    hash = "sha256-gdQ6fGaLqde8EQOy56kR6dFIKUs3PSelmujaee96Pi8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
