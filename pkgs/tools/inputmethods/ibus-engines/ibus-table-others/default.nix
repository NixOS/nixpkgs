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
  version = "1.3.21";

  src = fetchurl {
    url = "https://github.com/moebiuscurve/ibus-table-others/releases/download/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-/3ZDQCc/u2HKlL0+kZ0g4Gbjrkk++l3lSrWQz7CvwaQ=";
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

  meta = with lib; {
    isIbusEngine = true;
    description = "Various table-based input methods for IBus";
    homepage = "https://github.com/moebiuscurve/ibus-table-others";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      mudri
      McSinyx
    ];
  };
}
