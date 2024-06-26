{
  lib,
  fetchurl,
  gettext,
  pkg-config,
  texinfo,
  wrapGAppsHook3,
  buildPythonApplication,
  pycairo,
  pygobject3,
  gdk-pixbuf,
  gobject-introspection,
  gtk3,
  librsvg,
  alsa-utils,
  timidity,
  mpg123,
  vorbis-tools,
  csound,
  lilypond,
  automake,
  autoconf,
  txt2man,
}:

buildPythonApplication rec {
  pname = "solfege";
  version = "3.23.4";

  src = fetchurl {
    url = "https://alpha.gnu.org/gnu/solfege/solfege-${version}.tar.gz";
    sha256 = "0sc17vf4xz6gy0s0z9ghi68yskikdmyb4gdaxx6imrm40734k8mp";
  };

  patches = [
    ./css.patch
    ./menubar.patch
    ./texinfo.patch
    ./webbrowser.patch
  ];

  preConfigure = ''
    aclocal
    autoconf
  '';

  nativeBuildInputs = [
    automake
    autoconf
    gdk-pixbuf
    gettext
    pkg-config
    texinfo
    txt2man

    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    librsvg
  ];

  propagatedBuildInputs = [
    pycairo
    pygobject3
  ];

  preBuild = ''
    sed -i -e 's|wav_player=.*|wav_player=${alsa-utils}/bin/aplay|' \
           -e 's|midi_player=.*|midi_player=${timidity}/bin/timidity|' \
           -e 's|mp3_player=.*|mp3_player=${mpg123}/bin/mpg123|' \
           -e 's|ogg_player=.*|ogg_player=${vorbis-tools}/bin/ogg123|' \
           -e 's|csound=.*|csound=${csound}/bin/csound|' \
           -e 's|lilypond-book=.*|lilypond-book=${lilypond}/bin/lilypond-book|' \
           default.config
  '';

  format = "other";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Ear training program";
    homepage = "https://www.gnu.org/software/solfege/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      bjornfor
      orivej
      anthonyroussel
    ];
    mainProgram = "solfege";
  };
}
