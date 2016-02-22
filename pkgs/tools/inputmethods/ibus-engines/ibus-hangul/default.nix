{ stdenv, gnome, fetchFromGitHub, ibus, libhangul, autoconf, automake, gettext, libtool, librsvg,
  intltool, pkgconfig, pythonPackages, makeWrapper, gtk3, python }:

stdenv.mkDerivation rec {
  name = "ibus-hangul-${version}";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner  = "choehwanjin";
    repo   = "ibus-hangul";
    rev    = version;
    sha256 = "12l2spr32biqdbz01bzkamgq5gskbi6cd7ai343wqyy1ibjlkmp8";
  };

  buildInputs = [ ibus libhangul autoconf gettext automake libtool
    intltool pkgconfig python pythonPackages.pygobject3 gtk3 makeWrapper ];

  preConfigure = ''
    autoreconf --verbose --force --install
    intltoolize --automake --force --copy
  '';

  postInstall = ''
    wrapProgram $out/bin/ibus-setup-hangul \
      --prefix PYTHONPATH : $PYTHONPATH \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix GDK_PIXBUF_MODULE_FILE : ${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache \
      --prefix LD_LIBRARY_PATH : ${libhangul}/lib
  '';

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "Ibus Hangul engine.";
    homepage     = https://github.com/choehwanjin/ibus-hangul;
    license      = licenses.gpl2;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ ericsagnes ];
  };
}
