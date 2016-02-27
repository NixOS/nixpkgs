{ stdenv, fetchurl, makeWrapper
, intltool, pkgconfig
, gtk3, ibus, libhangul, librsvg, python3, pygobject3
}:

stdenv.mkDerivation rec {
  name = "ibus-hangul-${version}";
  version = "1.5.0";

  src = fetchurl {
    url = "https://github.com/choehwanjin/ibus-hangul/releases/download/${version}/${name}.tar.gz";
    sha256 = null;
  };

  buildInputs = [ gtk3 ibus libhangul python3 pygobject3 ];

  nativeBuildInputs = [ intltool makeWrapper pkgconfig ];

  postInstall = ''
    wrapProgram $out/bin/ibus-setup-hangul \
      --prefix PYTHONPATH : $PYTHONPATH \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix GDK_PIXBUF_MODULE_FILE : ${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache \
      --prefix LD_LIBRARY_PATH : ${libhangul}/lib
  '';

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "Ibus Hangul engine";
    homepage     = https://github.com/choehwanjin/ibus-hangul;
    license      = licenses.gpl2;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ ericsagnes ];
  };
}
