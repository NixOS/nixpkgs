{ lib
, buildPythonApplication
, fetchzip
, pygobject3
, pytestCheckHook
, gdk-pixbuf
, glib
, gobject-introspection
, gtk3
, python-linux-procfs
, python-ethtool
, wrapGAppsHook
}:

buildPythonApplication rec {
  pname = "tuna";
  version = "0.15";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/tuna/tuna.git/snapshot/tuna-v${version}.tar.gz";
    sha256 = "MwyLBwKz5ur1sBXHiCLq/Nq2u5aaiC+KzXqvGBmQii8=";
  };

  postPatch = ''
    mv tuna-cmd.py tuna/cmd.py

    substituteInPlace setup.py \
      --replace 'packages = ["tuna", "tuna/gui"],' \
                'packages = ["tuna", "tuna/gui"], entry_points={"console_scripts":["tuna=tuna.cmd:main"]},'

    substituteInPlace tuna/tuna_gui.py \
      --replace "self.binpath + 'pkexec'" "'/run/wrappers/bin/pkexec'" \
      --replace 'tuna_glade_dirs = [".", "tuna", "/usr/share/tuna"]' "tuna_glade_dirs = [ \"$out/share/tuna\" ]"
  '';

  nativeBuildInputs = [
    glib.dev
    gobject-introspection
    gtk3
    wrapGAppsHook
  ];

  propagatedBuildInputs = [ pygobject3 python-linux-procfs python-ethtool ];

  postInstall = ''
    mkdir -p $out/share/tuna
    cp tuna/tuna_gui.glade $out/share/tuna/
  '';

  # contains no tests
  doCheck = false;
  pythonImportsCheck = [ "tuna" ];

  meta = with lib; {
    description = "Thread and IRQ affinity setting GUI and cmd line tool";
    homepage = "https://git.kernel.org/pub/scm/utils/tuna/tuna.git";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ elohmeier ];
  };
}
