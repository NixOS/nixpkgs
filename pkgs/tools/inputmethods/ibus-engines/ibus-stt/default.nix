{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, pkg-config
, gst_all_1
, gst-deepspeech
, ibus
, pango
, python3
, gobject-introspection
, wrapGAppsHook
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "ibus-deepspeech";
  version = "unstable-2017-12-30";

  src = fetchFromGitHub {
    owner = "Elleo";
    repo = "ibus-deepspeech";
    rev = "3ea7c537e60e3ff66c566355c2b365febc91a91a";
    sha256 = "51rSPqen40drSfB60q/unc2EbX5lgJnPCIRoH4qq/AM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gobject-introspection # for setup hook
    wrapGAppsHook
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-good
    gst-deepspeech
    ibus
    pango
    (python3.withPackages (ps: [
      ps.pygobject3
      ps.gst-python
      (ps.toPythonModule ibus)
    ]))
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      url = "${src.meta.homepage}.git";
    };
  };

  meta = with lib; {
    isIbusEngine = true;
    description = "IBus plugin to allow any Linux application to make use of speech recognition";
    homepage = "https://github.com/Elleo/ibus-deepspeech";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jtojnar ];
  };
}
