{ stdenv, fetchurl, libcap, autoreconfHook }:

assert stdenv.isLinux -> libcap != null;

stdenv.mkDerivation rec {
  name = "ntp-4.2.8";

  src = fetchurl {
    url = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${name}.tar.gz";
    sha256 = "1vnqa1542d01xmlkw8f3rq57y360b2j7yxkkg9b11955nvw0v4if";
  };

  patches = [ ./no-openssl.patch ];

  configureFlags = ''
    --without-crypto
    ${if stdenv.isLinux then "--enable-linuxcaps" else ""}
  '';

  buildInputs = [ autoreconfHook ] ++ stdenv.lib.optional stdenv.isLinux libcap;

  postInstall = "rm -rf $out/share/doc";

  meta = {
    homepage = http://www.ntp.org/;
    description = "An implementation of the Network Time Protocol";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
