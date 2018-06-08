{ stdenv, fetchFromGitHub, ibus, ibus-table, pkgconfig, python3 }:

stdenv.mkDerivation rec {
  pname = "ibus-table-others";
  version = "1.3.9";

  src = fetchFromGitHub {
    owner = "moebiuscurve";
    repo = pname;
    rev = version;
    sha256 = "0iyhfb9261q4g1ldvddiqsf03fhpagailbxw3a7pig1858v15izf";
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
