{ python3
, lib
, fetchFromGitLab
}:

python3.pkgs.buildPythonPackage rec {
  pname = "hid-tools";
<<<<<<< HEAD
  version = "0.4";
=======
  version = "0.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "setuptools";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libevdev";
    repo = "hid-tools";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-pxU1BvB+rjc5sptafMGnWi+vWPNDyCyUv8gTWg6z5hU=";
=======
    sha256 = "r496SKBGgHriIhriWYhhCSiChQUKhnHT/lEx9sEoT/0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = with python3.pkgs; [
    libevdev
    parse
    pyyaml
    click
    pyudev
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  # Tests require /dev/uhid
  doCheck = false;

  meta = with lib; {
    description = "Python scripts to manipulate HID data";
    homepage = "https://gitlab.freedesktop.org/libevdev/hid-tools";
    license = licenses.mit;
    maintainers = teams.freedesktop.members;
  };
}
