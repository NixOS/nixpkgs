{ stdenv, fetchurl, imagemagickBig, pkgconfig, python, pygtk, perl
, libX11, libv4l, qt4, lzma, gtk2
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "zbar";
  version = "0.10";
  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${version}/${name}.tar.bz2";
    sha256 = "1imdvf5k34g1x2zr6975basczkz3zdxg6xnci50yyp5yvcwznki3";
  };

  buildInputs =
    [ imagemagickBig pkgconfig python pygtk perl libX11
      libv4l qt4 lzma gtk2 ];

  configureFlags = ["--disable-video"];

  meta = with stdenv.lib; {
    description = "Bar code reader";
    longDescription = ''
      ZBar is an open source software suite for reading bar codes from various
      sources, such as video streams, image files and raw intensity sensors. It
      supports many popular symbologies (types of bar codes) including
      EAN-13/UPC-A, UPC-E, EAN-8, Code 128, Code 39, Interleaved 2 of 5 and QR
      Code.
    '';
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
    homepage = http://zbar.sourceforge.net/;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://zbar.sourceforge.net/";
    };
  };
}
