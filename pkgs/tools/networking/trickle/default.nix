{ stdenv, fetchurl, libevent, libtirpc }:

stdenv.mkDerivation rec {
  name = "trickle-1.07";

  src = fetchurl {
    url = "https://monkey.org/~marius/trickle/${name}.tar.gz";
    sha256 = "0s1qq3k5mpcs9i7ng0l9fvr1f75abpbzfi1jaf3zpzbs1dz50dlx";
  };

  buildInputs = [ libevent libtirpc ];

  preConfigure = ''
    sed -i 's|libevent.a|libevent.so|' configure
  '';

  preBuild = ''
    sed -i '/#define in_addr_t/ s:^://:' config.h
  '';

  NIX_LDFLAGS = [ "-levent" "-ltirpc" ];
  NIX_CFLAGS_COMPILE = [ "-I${libtirpc.dev}/include/tirpc" ];

  configureFlags = [ "--with-libevent" ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Lightweight userspace bandwidth shaper";
    license = stdenv.lib.licenses.bsd3;
    homepage = "https://monkey.org/~marius/pages/?page=trickle";
    platforms = stdenv.lib.platforms.linux;
  };
}
