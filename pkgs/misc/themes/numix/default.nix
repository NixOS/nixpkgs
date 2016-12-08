{ stdenv, fetchFromGitHub, sass, glib, libxml2, gdk_pixbuf
, gtk-engine-murrine
}:

stdenv.mkDerivation rec {
  version = "2016-11-19";
  name = "numix-gtk-theme-${version}";

  src = fetchFromGitHub {
    repo = "numix-gtk-theme";
    owner = "numixproject";
    rev = "0e4a840bd1ec434ba660418caaa59ada05d8660e";
    sha256 = "09nacjwrl5k3dgji2smdv6q5v23qjzfayic044bnjfm5d3p3yf6n";
  };

  nativeBuildInputs = [ sass glib libxml2 gdk_pixbuf ];

  buildInputs = [ gtk-engine-murrine ];

  postPatch = ''
    substituteInPlace Makefile --replace '$(DESTDIR)'/usr $out
    patchShebangs .
  '';

  meta = {
    description = "Modern flat theme with a combination of light and dark elements (GNOME, Unity, Xfce and Openbox)";
    homepage = https://numixproject.org;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
