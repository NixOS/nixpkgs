{ lib, stdenv, fetchurl, ibus, ibus-table, pkg-config, python3 }:

stdenv.mkDerivation rec {
  pname = "ibus-table-others";
  version = "1.3.16";

  src = fetchurl {
    url = "https://github.com/moebiuscurve/ibus-table-others/releases/download/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-TybqFQ2EgYo4zCYXwDJ0dke7HSzkZXs0lG2zR2XmlG4=";
  };

  nativeBuildInputs = [ pkg-config python3 ];
  buildInputs = [ ibus ibus-table ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    isIbusEngine = true;
    description  = "Various table-based input methods for IBus";
    homepage     = "https://github.com/moebiuscurve/ibus-table-others";
    license      = licenses.gpl3;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ mudri McSinyx ];
  };
}
