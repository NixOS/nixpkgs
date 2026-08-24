{
  lib,
  stdenv,
  fetchurl,
  ibus,
  ibus-table,
  pkg-config,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "ibus-table-others";
  version = "1.3.22";

  src = fetchurl {
    url = "https://github.com/moebiuscurve/ibus-table-others/releases/download/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-DnBNOj0fqCkoJThJvEej0qxHAsVgLHm6r4qcOLCrMqM=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
  ];
  buildInputs = [
    ibus
    ibus-table
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  meta = {
    isIbusEngine = true;
    description = "Various table-based input methods for IBus";
    homepage = "https://github.com/moebiuscurve/ibus-table-others";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      mudri
      McSinyx
    ];
  };
}
