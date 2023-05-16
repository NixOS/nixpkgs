{ lib
, stdenv
, python3Packages
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, nix-update-script
, s-tui
, testers
}:

python3Packages.buildPythonPackage rec {
  pname = "s-tui";
  version = "1.1.4";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "sha256-soVrmzlVy0zrqvOclR7SfPphp4xAEHv+xdr0NN19ye0=";
  };

  propagatedBuildInputs = with python3Packages; [
    urwid
    psutil
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion { package = s-tui; };
  };

  meta = with lib; {
    homepage = "https://amanusk.github.io/s-tui/";
    description = "Stress-Terminal UI monitoring tool";
    license = licenses.gpl2;
    maintainers = with maintainers; [ infinisil ];
    broken = stdenv.isDarwin; # https://github.com/amanusk/s-tui/issues/49
  };
}
