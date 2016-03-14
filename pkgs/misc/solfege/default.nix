{ stdenv, fetchurl, pkgconfig, python, pygtk, gettext, texinfo
, ghostscript, pysqlite, librsvg, gdk_pixbuf, txt2man, timidity, mpg123
, alsaUtils, vorbis-tools, csound, lilypond
, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "solfege-3.22.2";

  src = fetchurl {
    url = "mirror://sourceforge/solfege/${name}.tar.gz";
    sha256 = "1r4g93ka7i8jh5glii5nza0zq0wy4sw0gfzpvkcrhj9yr1h0jsp4";
  };

  buildInputs = [ pkgconfig python pygtk gettext texinfo
    ghostscript pysqlite librsvg gdk_pixbuf txt2man makeWrapper
  ];

  preBuild = ''
    sed -i -e 's|wav_player=.*|wav_player=${alsaUtils}/bin/aplay|' \
           -e 's|midi_player=.*|midi_player=${timidity}/bin/timidity|' \
           -e 's|mp3_player=.*|mp3_player=${mpg123}/bin/mpg123|' \
           -e 's|ogg_player=.*|ogg_player=${vorbis-tools}/bin/ogg123|' \
           -e 's|csound=.*|csound=${csound}/bin/csound|' \
           -e 's|lilypond-book=.*|lilypond-book=${lilypond}/bin/lilypond-book|' \
           default.config
  '';

  postInstall = ''
      set -x
      wrapProgram "$out/bin/solfege" \
          --prefix PYTHONPATH ':' "$PYTHONPATH" \
          --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  meta = with stdenv.lib; {
    description = "Ear training program";
    homepage = http://www.solfege.org/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
