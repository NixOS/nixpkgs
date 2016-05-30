{ stdenv, fetchurl, openssl, expat, libevent }:

stdenv.mkDerivation rec {
  name = "unbound-${version}";
  version = "1.5.8";

  src = fetchurl {
    url = "http://unbound.net/downloads/${name}.tar.gz";
    sha256 = "33567a20f73e288f8daa4ec021fbb30fe1824b346b34f12677ad77899ecd09be";
  };

  outputs = [ "out" "lib" "man" ]; # "dev" would only split ~20 kB

  buildInputs = [ openssl expat libevent ];

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-libexpat=${expat.dev}"
    "--with-libevent=${libevent.dev}"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--sbindir=\${out}/bin"
    "--enable-pie"
    "--enable-relro-now"
  ];

  installFlags = [ "configfile=\${out}/etc/unbound/unbound.conf" ];

  # get rid of runtime dependencies on $dev outputs
  postInstall = ''substituteInPlace "$lib/lib/libunbound.la" ''
    + stdenv.lib.concatMapStrings
      (pkg: " --replace '-L${pkg.dev}/lib' '-L${pkg.out}/lib' ")
      [ openssl expat libevent ];

  meta = with stdenv.lib; {
    description = "Validating, recursive, and caching DNS resolver";
    license = licenses.bsd3;
    homepage = http://www.unbound.net;
    maintainers = with maintainers; [ ehmry fpletz ];
    platforms = stdenv.lib.platforms.unix;
  };
}
