{ stdenv, fetchFromGitHub, pkgconfig, ibus, ibus-table, python3 }:

stdenv.mkDerivation rec {
  pname = "ibus-table-vietnamese";
  version = "20190825";

  src = fetchFromGitHub {
    owner = "McSinyx";
    repo = "ibus-table-vietnamese";
    rev = "32d577929a2f65c20287d773f112354a41aa52e6";
    sha256 = "0i86rbhrjxbvkkxib37hsvrm610qi2gi624an94plw243hffnz32";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ibus ibus-table python3 ];

  preBuild = ''
    export HOME=$(mktemp -d)/ibus-table-vietnamese
  '';

  preInstall = ''
    export DATADIR=$out/share
  '';

  postFixup = ''
    rm -rf $HOME
  '';

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "Telex and VNI IM for ibus-table";
    homepage     = https://github.com/McSinyx/ibus-table-vietnamese;
    license      = licenses.gpl3Plus;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ McSinyx ];
  };
}
