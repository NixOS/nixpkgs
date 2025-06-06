{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook3,
  xflux,
  gtk3,
  gobject-introspection,
  pango,
  gdk-pixbuf,
  atk,
  libayatana-appindicator,
  redshift,
}:

python3Packages.buildPythonApplication rec {
  pname = "xflux-gui";
  version = "2.0";

  src = fetchFromGitHub {
    repo = "xflux-gui";
    owner = "xflux-gui";
    tag = "v${version}";
    hash = "sha256-/hIJYfumpPtkgiQD2leAwym1yxMSis6M6rlIpWu1Qcc=";
  };

  postPatch = ''
    patchPythonScript src/fluxgui/fluxapp.py
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
    pango
    gdk-pixbuf
    atk
  ];

  buildInputs = [
    xflux
    gtk3
  ];

  dependencies =
    with python3Packages;
    [
      pyxdg
      pexpect
      pygobject3
    ]
    ++ [ libayatana-appindicator ];

  dontWrapGApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--prefix PATH : ${lib.makeBinPath [ redshift ]}"
  ];

  meta = {
    description = "Better lighting for Linux. Open source GUI for xflux";
    homepage = "https://justgetflux.com/linux.html";
    mainProgram = "fluxgui";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sheenobu ];
    platforms = lib.platforms.linux;
  };
}
