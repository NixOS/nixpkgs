{ stdenv, fetchurl }:

stdenv.mkDerivation (rec {
  name = "dante-${version}";
  version = "1.4.1";

  src = fetchurl {
    url = "https://www.inet.no/dante/files/${name}.tar.gz";
    sha256 = "0lsg3hk8zd2h9f08s13bn4l4pvyyzkj4gr4ppwa7vj7gdyyk5lmn";
  };

  configureFlags = [
    "--with-libc=libc.so.6"
  ];

  meta = {
    description = "A circuit-level SOCKS client/server that can be used to provide convenient and secure network connectivity.";
    homepage    = "https://www.inet.no/dante/";
    maintainers = [ stdenv.lib.maintainers.arobyn ];
    license     = stdenv.lib.licenses.bsdOriginal;
    platforms   = stdenv.lib.platforms.linux;
  };
})
