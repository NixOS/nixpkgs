{ stdenv, fetchurl, paxctl }:

stdenv.mkDerivation rec {
  name    = "paxtest-${version}";
  version = "0.9.14";

  src = fetchurl {
    url    = "https://www.grsecurity.net/~spender/${name}.tar.gz";
    sha256 = "0j40h3x42k5mr5gc5np4wvr9cdf9szk2f46swf42zny8rlgxiskx";
  };

  enableParallelBuilding = true;

  makefile     = "Makefile.psm";
  makeFlags    = [ "PAXBIN=${paxctl}/bin/paxctl" "BINDIR=$(out)/bin" "RUNDIR=$(out)/lib/paxtest" ];
  installFlags = ''DESTDIR=""'';

  meta = with stdenv.lib; {
    description = "Test various memory protection measures";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainer  = with maintainers; [ copumpkin joachifm ];
  };
}
