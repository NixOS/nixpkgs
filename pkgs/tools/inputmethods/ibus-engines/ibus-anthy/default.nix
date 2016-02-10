{ stdenv, fetchFromGitHub, makeWrapper, ibus, anthy, intltool, pkgconfig, glib, gobjectIntrospection,
  python, pythonPackages, gtk3, libtool, automake, autoconf }:

stdenv.mkDerivation rec {
  name = "ibus-anthy-${version}";
  version = "1.5.8";

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "IBus interface to the anthy input method";
    homepage     = http://wiki.github.com/fujiwarat/ibus-anthy;
    license      = licenses.gpl2Plus;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ gebner ericsagnes ];
  };

  preConfigure = "./autogen.sh --prefix=$out";

  configureFlags = "--with-anthy-zipcode=${anthy}/share/anthy/zipcode.t";

  buildInputs = [ makeWrapper ibus anthy intltool pkgconfig glib gobjectIntrospection
    python pythonPackages.pygobject3 gtk3 libtool automake autoconf ];

  postFixup = ''
    substituteInPlace $out/share/ibus/component/anthy.xml --replace \$\{exec_prefix\} $out
    for file in "$out"/libexec/*; do
      wrapProgram "$file" \
        --prefix PYTHONPATH : $PYTHONPATH \
        --prefix GI_TYPELIB_PATH : $GI_TYPELIB_PATH:$out/lib/girepository-1.0
    done
  '';

  src = fetchFromGitHub {
    owner  = "ibus";
    repo   = "ibus-anthy";
    rev    = version;
    sha256 = "1laxwpnhgihv4dz5cgcz6d0a0880r93n7039ciz1m53hdzapwi4a";
  };
}
