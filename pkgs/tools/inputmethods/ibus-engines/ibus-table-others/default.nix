{ stdenv, fetchurl, ibus, ibus-table, pkgconfig, python3 }:

stdenv.mkDerivation rec {
  name = "ibus-table-others-${version}";
  version = "1.3.9";

  src = fetchurl {
    url = "https://github.com/moebiuscurve/ibus-table-others/releases/download/${version}/${name}.tar.gz";
    sha256 = "0270a9njyzb1f8nw5w9ghwxcl3m6f13d8p8a01fjm8rnjs04mcb3";
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
    homepage     = https://github.com/moebiuscurve/ibus-table-others;
    license      = licenses.gpl3;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ mudri ];
  };
}
