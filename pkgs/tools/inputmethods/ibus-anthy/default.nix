{ stdenv, fetchurl, makeWrapper, ibus, anthy, intltool, pkgconfig, glib, gobjectIntrospection, python, pythonPackages }:

let version = "1.5.4";
in stdenv.mkDerivation {
  name = "ibus-anthy-${version}";

  meta = with stdenv.lib; {
    description = "IBus interface to the anthy input method";
    homepace    = https://code.google.com/p/ibus/;
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ gebner ];
  };

  buildInputs = [ makeWrapper ibus anthy intltool pkgconfig glib gobjectIntrospection python pythonPackages.pygobject3 ];

  postFixup = ''
    for file in "$out"/libexec/*; do
      wrapProgram "$file" \
        --prefix PYTHONPATH : $PYTHONPATH \
        --prefix GI_TYPELIB_PATH : $GI_TYPELIB_PATH:$out/lib/girepository-1.0
    done
  '';

  src = fetchurl {
    url = "https://ibus.googlecode.com/files/ibus-anthy-${version}.tar.gz";
    sha256 = "4c0a8b88a2c547e72173a7d682d82797f6c65fe712abe5f3b89495d4eec7b031";
  };
}
