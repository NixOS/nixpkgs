{ stdenv, fetchurl, ibus, ibus-table, pkgconfig, python3 }:

stdenv.mkDerivation rec {
  pname = "ibus-table-others";
  version = "1.3.11";

  src = fetchurl {
    url = "https://github.com/moebiuscurve/ibus-table-others/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "0763wnlklcs3d8fk21nkp7dgn4qzqgxh1s24q3kl8gzgng2a88jj";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ibus ibus-table python3 ];

  preBuild = ''
    export HOME=$(mktemp -d)/ibus-table-others
  '';

  postFixup = ''
    rm -rf $HOME
  '';

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "Various table-based input methods for IBus";
    homepage     = "https://github.com/moebiuscurve/ibus-table-others";
    license      = licenses.gpl3;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ mudri ];
  };
}
