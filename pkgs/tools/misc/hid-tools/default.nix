{ python3
, lib
, fetchFromGitLab
}:

python3.pkgs.buildPythonPackage rec {
  pname = "hid-tools";
  version = "0.7";

  format = "pyproject";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libevdev";
    repo = "hid-tools";
    rev = version;
    hash = "sha256-h880jJcZDc9pIPf+nr30wu2i9y3saAKFZpooJ4MF67E=";
  };

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    pypandoc
  ];

  propagatedBuildInputs = with python3.pkgs; [
    libevdev
    parse
    pyyaml
    click
    pyudev
    typing-extensions
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  # Tests require /dev/uhid
  # https://gitlab.freedesktop.org/libevdev/hid-tools/-/issues/18#note_166353
  doCheck = false;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pypandoc_binary" "pypandoc"
  '';

  meta = with lib; {
    description = "Python scripts to manipulate HID data";
    homepage = "https://gitlab.freedesktop.org/libevdev/hid-tools";
    license = licenses.mit;
    maintainers = teams.freedesktop.members;
  };
}
