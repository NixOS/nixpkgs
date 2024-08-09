{
  lib,
  python3,
  fetchurl,
  glib,
  gobject-introspection,
  gtk3,
  wrapGAppsHook3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tuna";
  version = "0.19";
  pyproject = true;

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/utils/tuna/tuna.git/snapshot/tuna-v${version}.tar.gz";
    hash = "sha256-t10CxtwnTOg1uQgm6mTrNUIU8LkXJ3BkTycjWteQvuU=";
  };

  postPatch = ''
    mv tuna-cmd.py tuna/cmd.py

    substituteInPlace setup.py \
      --replace-fail 'packages = ["tuna", "tuna/gui"],' \
                     'packages = ["tuna", "tuna/gui"], entry_points={"console_scripts":["tuna=tuna.cmd:main"]},'

    substituteInPlace tuna/tuna_gui.py \
      --replace-fail "self.binpath + 'pkexec'" "'/run/wrappers/bin/pkexec'" \
      --replace-fail 'tuna_glade_dirs = [".", "tuna", "/usr/share/tuna"]' "tuna_glade_dirs = [ \"$out/share/tuna\" ]"
  '';

  build-system = with python3.pkgs; [ setuptools ];

  nativeBuildInputs = [
    glib.dev
    gobject-introspection
    gtk3
    wrapGAppsHook3
  ];

  dependencies = with python3.pkgs; [
    pygobject3
    python-linux-procfs
    ethtool
  ];

  postInstall = ''
    mkdir -p $out/share/tuna
    cp tuna/tuna_gui.glade $out/share/tuna/
  '';

  # contains no tests
  doCheck = false;
  pythonImportsCheck = [ "tuna" ];

  meta = with lib; {
    description = "Thread and IRQ affinity setting GUI and cmd line tool";
    mainProgram = "tuna";
    homepage = "https://git.kernel.org/pub/scm/utils/tuna/tuna.git";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
