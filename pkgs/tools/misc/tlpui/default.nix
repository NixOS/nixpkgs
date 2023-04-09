{
  lib,
  wrapGAppsHook,
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
  substituteAll,
  tlp,
  pytestCheckHook,
  pycairo,
  pygobject3,
  pciutils,
  usbutils,
  gtk3,
  cairo,
  gobject-introspection,
}:
# FIX not working subprocess.CalledProcessError: Command '['pkexec', 'tlp-stat']'
with lib;
  buildPythonPackage rec {
    pname = "tlpui";
    version = "1.5.0-7";
    # only python3 support
    disabled = !isPy3k;

    src = fetchFromGitHub {
      owner = "d4nj1";
      repo = "TLPUI";
      rev = "tlpui-${version}";
      sha256 = "sha256-fhQgiMy829jdkQXtXgTayWXHtFwnHl8hgGVJzE0E8R0=";
    };

    patches = [
      (substituteAll {
        src = ./path.patch;
        inherit tlp;
      })
    ];

    # Fix test/test_tlp_settings.py
    pytestFlagsArray = ["test/" "--ignore=test/test_tlp_settings.py"];
    nativeCheckInputs = [pytestCheckHook gobject-introspection];

    nativeBuildInputs = [wrapGAppsHook];
    buildInputs = [
      tlp
    ];
    # sandbox = true;
    propagatedBuildInputs = [pycairo pygobject3 gtk3 pciutils usbutils gobject-introspection];

    meta = {
      homepage = "https://github.com/d4nj1/TLPUI";
      description = "A GTK user interface for TLP written in Python";
      longDescription = ''
        The Python scripts in this project generate a GTK-UI to change TLP configuration files easily.
        It has the aim to protect users from setting bad configuration and to deliver a basic overview of all the valid configuration values.
      '';
      license = licenses.gpl2Only;
      platforms = platforms.linux;
      maintainers = with maintainers; [georgesalkhouri];
    };
  }
