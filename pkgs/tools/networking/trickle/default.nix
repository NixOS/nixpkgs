{ stdenv, fetchurl, libevent }:

stdenv.mkDerivation rec {
  name = "trickle-1.07";

  src = fetchurl {
    url = "http://monkey.org/~marius/trickle/${name}.tar.gz";
    sha256 = "0s1qq3k5mpcs9i7ng0l9fvr1f75abpbzfi1jaf3zpzbs1dz50dlx";
  };

  buildInputs = [ libevent ];

  preConfigure = ''
    sed -i 's|libevent.a|libevent.so|' configure
  '';

  preBuild = ''
    sed -i '/#define in_addr_t/ s:^://:' config.h
  '';

  LDFLAGS = "-levent";

  configureFlags = "--with-libevent";

  hardeningDisable = [ "format" ];

  meta = {
    description = "Lightweight userspace bandwidth shaper";
    license = stdenv.lib.licenses.bsd3;
    homepage = http://monkey.org/~marius/pages/?page=trickle;
    platforms = stdenv.lib.platforms.linux;
  };
}
