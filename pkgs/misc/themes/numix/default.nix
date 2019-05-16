{ stdenv, fetchFromGitHub, sass, glib, libxml2, gdk_pixbuf
, gtk-engine-murrine
}:

stdenv.mkDerivation rec {
  version = "2.6.7";
  name = "numix-gtk-theme-${version}";

  src = fetchFromGitHub {
    repo = "numix-gtk-theme";
    owner = "numixproject";
    rev = version;
    sha256 = "12mw0kr0kkvg395qlbsvkvaqccr90cmxw5rrsl236zh43kj8grb7";
  };

  nativeBuildInputs = [ sass glib libxml2 gdk_pixbuf ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = ''
    substituteInPlace Makefile --replace '$(DESTDIR)'/usr $out
    patchShebangs .
  '';

  meta = {
    description = "Modern flat theme with a combination of light and dark elements (GNOME, Unity, Xfce and Openbox)";
    homepage = https://numixproject.github.io;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
