{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "nmon-${version}";
  version = "16g";

  src = fetchurl {
    url = "http://sourceforge.net/projects/nmon/files/lmon${version}.c";
    sha256 = "127n8xvmg7byp42sm924mdr7hd3bsfsxpryzahl0cfsh7dlxv0ns";
  };

  builder = ./builder.sh;

  buildInputs =
    [ ncurses ];

  meta = with stdenv.lib; {
    description = "Nigel's performance Monitor for Linux";
    homepage = http://nmon.sourceforge.net/pmwiki.php;
    license = licenses.gpl3;
    maintainers = with maintainers; [ vquintin ];
  };
}

