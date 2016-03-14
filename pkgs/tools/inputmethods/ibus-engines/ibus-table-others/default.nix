{ stdenv, fetchurl, ibus, ibus-table, pkgconfig, python3 }:

stdenv.mkDerivation rec {
  name = "ibus-table-others-${version}";
  version = "1.3.7";

  src = fetchurl {
    url = "https://github.com/moebiuscurve/ibus-table-others/releases/download/${version}/${name}.tar.gz";
    sha256 = "0vmz82il796062jbla5pawsr5dqyhs7ald7xjp84zfccc09dg9kx";
  };

  buildInputs = [ ibus ibus-table pkgconfig python3 ];

  preBuild = ''
    export HOME=$(mktemp -d)/ibus-table-others
  '';

  postFixup = ''
    rm -rf $HOME
  '';

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "Various table-based input methods for IBus";
    homepage     = https://github.com/moebiuscurve/ibus-table-others;
    license      = licenses.gpl3;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ mudri ];
  };
}
