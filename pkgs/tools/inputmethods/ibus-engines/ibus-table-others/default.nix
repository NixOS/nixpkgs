{ lib, stdenv, fetchurl, ibus, ibus-table, pkg-config, python3 }:

stdenv.mkDerivation rec {
  pname = "ibus-table-others";
  version = "1.3.12";

  src = fetchurl {
    url = "https://github.com/moebiuscurve/ibus-table-others/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-2k7JtLr+zO71rbTz11CCiIPx+orn0dw/Y8m47WfRDEU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ibus ibus-table python3 ];

  preBuild = ''
    export HOME=$(mktemp -d)/ibus-table-others
  '';

  postFixup = ''
    rm -rf $HOME
  '';

  meta = with lib; {
    isIbusEngine = true;
    description  = "Various table-based input methods for IBus";
    homepage     = "https://github.com/moebiuscurve/ibus-table-others";
    license      = licenses.gpl3;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ mudri ];
  };
}
