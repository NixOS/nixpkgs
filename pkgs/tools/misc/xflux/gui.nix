{
  lib,
  fetchFromGitHub,
  buildPythonApplication,
  python3Packages,
  wrapGAppsHook3,
  xflux,
  gtk3,
  gobject-introspection,
  pango,
  gdk-pixbuf,
  atk,
  pexpect,
  pygobject3,
  pyxdg,
  libappindicator-gtk3,
}:
buildPythonApplication rec {
  pname = "xflux-gui";
  version = "1.2.0";

  src = fetchFromGitHub {
    repo = "xflux-gui";
    owner = "xflux-gui";
    rev = "v${version}";
    sha256 = "09zphcd9821ink63636swql4g85hg6lpsazqg1mawlk9ikc8zbps";
  };

  propagatedBuildInputs = [
    pyxdg
    pexpect
    pygobject3
  ];

  buildInputs = [
    xflux
    gtk3
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
    pango
    gdk-pixbuf
    atk
    libappindicator-gtk3
  ];

  postPatch = ''
    substituteInPlace src/fluxgui/xfluxcontroller.py \
      --replace "pexpect.spawn(\"xflux\"" "pexpect.spawn(\"${xflux}/bin/xflux\""
  '';

  postFixup = ''
    wrapGAppsHook
    wrapPythonPrograms
    patchPythonScript $out/${python3Packages.python.sitePackages}/fluxgui/fluxapp.py
  '';

  meta = {
    description = "Better lighting for Linux. Open source GUI for xflux";
    homepage = "https://justgetflux.com/linux.html";
    license = lib.licenses.unfree; # marked as unfree since the source code contains a copy of the unfree xflux binary
    maintainers = [ lib.maintainers.sheenobu ];
    platforms = lib.platforms.linux;
  };
}
