{ stdenv, fetchurl
, vala, gobject-introspection, intltool, python2Packages, glib
, pkgconfig
, libgee, json-glib, marisa, libkkc-data
}:

stdenv.mkDerivation rec {
  pname = "libkkc";
  version = "0.3.5";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "${meta.homepage}/releases/download/v${version}/${name}.tar.gz";
    sha256 = "89b07b042dae5726d306aaa1296d1695cb75c4516f4b4879bc3781fe52f62aef";
  };

  nativeBuildInputs = [
    vala gobject-introspection
    python2Packages.python python2Packages.marisa
    intltool glib pkgconfig
  ];

  buildInputs = [ marisa libkkc-data ];
  enableParallelBuilding = true;

  propagatedBuildInputs = [ libgee json-glib ];

  postInstall = ''
    ln -s ${libkkc-data}/lib/libkkc/models $out/share/libkkc/models
  '';

  meta = with stdenv.lib; {
    description = "Japanese Kana Kanji conversion input method library";
    homepage    = https://github.com/ueno/libkkc;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ vanzef ];
    platforms   = platforms.linux;
  };
}
