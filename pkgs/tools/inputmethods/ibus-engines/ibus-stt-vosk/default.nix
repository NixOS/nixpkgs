{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gst_all_1
, gst-vosk
, ibus
, pango
, gtk4
, libadwaita
, python3
, gobject-introspection
, wrapGAppsHook4
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "ibus-stt-vosk";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "PhilippeRo";
    repo = "IBus-Speech-To-Text";
    rev = version;
    sha256 = "K3l9glsnaX0G/O/kXUlh6KpQ/dr2mipRqSOdjOhoROM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection # for setup hook
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base # for audioconvert
    gst_all_1.gst-plugins-good # for pulsesrc
    gst-vosk
    ibus
    pango
    gtk4
    libadwaita
    (python3.withPackages (ps: [
      ps.pygobject3
      ps.gst-python
      ps.babel
      (ps.toPythonModule ibus)
    ]))
  ];

  postPatch = ''
    substituteInPlace engine/meson.build --replace 'meson.project_license()' 'meson.project_license()[0]'
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = with lib; {
    isIbusEngine = true;
    description = "Speech to text IBus engine using VOSK";
    homepage = "https://github.com/PhilippeRo/IBus-Speech-To-Text";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jtojnar ];
  };
}
