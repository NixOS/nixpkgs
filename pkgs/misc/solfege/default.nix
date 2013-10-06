{ stdenv, fetchurl, pkgconfig, python, pygtk, gettext, texinfo
, ghostscript, pysqlite, librsvg, gdk_pixbuf, txt2man, timidity, mpg123
, alsaUtils, vorbisTools, csound, lilypond
, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "solfege-3.22.0";

  src = fetchurl {
    url = "mirror://sourceforge/solfege/${name}.tar.gz";
    sha256 = "10klrhdb1n67xd4bndk6z6idyf0pvwz7hcdg9ibalms7ywl3b23x";
  };

  buildInputs = [ pkgconfig python pygtk gettext texinfo
    ghostscript pysqlite librsvg gdk_pixbuf txt2man makeWrapper
  ];

  preBuild = ''
    sed -i -e 's|wav_player=.*|wav_player=${alsaUtils}/bin/aplay|' \
           -e 's|midi_player=.*|midi_player=${timidity}/bin/timidity|' \
           -e 's|mp3_player=.*|mp3_player=${mpg123}/bin/mpg123|' \
           -e 's|ogg_player=.*|ogg_player=${vorbisTools}/bin/ogg123|' \
           -e 's|csound=.*|csound=${csound}/bin/csound|' \
           -e 's|lilypond-book=.*|lilypond-book=${lilypond}/bin/lilypond-book|' \
           default.config
  '';

  postInstall = ''
      set -x
      find "${librsvg}" "${gdk_pixbuf}" -name loaders.cache -print0 | xargs -0 cat > "$out/gdk-pixbuf.loaders"
      wrapProgram "$out/bin/solfege" \
          --prefix PYTHONPATH ':' "$PYTHONPATH" \
          --set GDK_PIXBUF_MODULE_FILE "$out/gdk-pixbuf.loaders"
  '';

  meta = {
    description = "Ear training program";
    homepage = http://www.solfege.org/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ bjornfor ];
  };
}
