{ python3
, lib
, fetchFromGitLab
}:

python3.pkgs.buildPythonPackage rec {
  pname = "hid-tools";
  version = "0.4";

  format = "setuptools";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libevdev";
    repo = "hid-tools";
    rev = version;
    hash = "sha256-pxU1BvB+rjc5sptafMGnWi+vWPNDyCyUv8gTWg6z5hU=";
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
