{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "micro-httpd-20140814";

  src = fetchurl {
    url   = "http://acme.com/software/micro_httpd/micro_httpd_14Aug2014.tar.gz";
    sha256 = "0mlm24bi31s0s8w55i0sysv2nc1n2x4cfp6dm47slz49h2fz24rk";
  };

  preBuild = ''
    makeFlagsArray=(BINDIR="$out/bin" MANDIR="$out/share/man/man8")
    mkdir -p $out/bin
    mkdir -p $out/share/man/man8
  '';

  meta = with stdenv.lib; {
    homepage    = "http://acme.com/software/micro_httpd/";
    description = "A really small HTTP server";
    license     = licenses.bsd2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ copumpkin ];
  };
}

