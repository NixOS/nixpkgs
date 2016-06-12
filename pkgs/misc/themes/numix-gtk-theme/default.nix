{ stdenv, fetchFromGitHub, sass, glib, libxml2, gdk_pixbuf
, gtk-engine-murrine
}:

stdenv.mkDerivation rec {
  version = "2016-06-12";
  name = "numix-gtk-theme-${version}";

  src = fetchFromGitHub {
    repo = "numix-gtk-theme";
    owner = "numixproject";
    rev = "1d941a15971f43fb2f5675c7059bf313b78797fc";
    sha256 = "14b1gl761acdza4bkqr6dvsblvi2wsph79j5jircxfd3wgvm756i";
  };

  nativeBuildInputs = [ sass glib libxml2 gdk_pixbuf ];

  buildInputs = [ gtk-engine-murrine ];

  postPatch = ''
    substituteInPlace Makefile --replace '$(DESTDIR)'/usr $out
  '';

  meta = {
    description = "Modern flat theme with a combination of light and dark elements (GNOME, Unity, Xfce and Openbox)";
    homepage = https://numixproject.org;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
