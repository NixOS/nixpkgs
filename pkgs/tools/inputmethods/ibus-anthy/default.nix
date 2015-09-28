{ stdenv, fetchurl, makeWrapper, ibus, anthy, intltool, pkgconfig, glib, gobjectIntrospection, python, pythonPackages }:

stdenv.mkDerivation rec {
  name = "ibus-anthy-${version}";
  version = "1.5.7";

  meta = with stdenv.lib; {
    description = "IBus interface to the anthy input method";
    homepage    = http://wiki.github.com/fujiwarat/ibus-anthy;
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ gebner ];
  };

  configureFlags = "--with-anthy-zipcode=${anthy}/share/anthy/zipcode.t";

  buildInputs = [ makeWrapper ibus anthy intltool pkgconfig glib gobjectIntrospection python pythonPackages.pygobject3 ];

  postFixup = ''
    substituteInPlace $out/share/ibus/component/anthy.xml --replace \$\{exec_prefix\} $out
    for file in "$out"/libexec/*; do
      wrapProgram "$file" \
        --prefix PYTHONPATH : $PYTHONPATH \
        --prefix GI_TYPELIB_PATH : $GI_TYPELIB_PATH:$out/lib/girepository-1.0
    done
  '';

  src = fetchurl {
    url = "https://github.com/ibus/ibus-anthy/releases/download/${version}/${name}.tar.gz";
    sha256 = "00sjrfhghrgkqm72mf39f8sz6wr4fwvvs9mn2alaldhgr5v0c861";
  };
}
