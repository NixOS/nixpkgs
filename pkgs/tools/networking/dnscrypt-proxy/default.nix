{ stdenv, fetchurl, libsodium, pkgconfig, systemd }:

stdenv.mkDerivation rec {
  name = "dnscrypt-proxy-${version}";
  version = "1.6.0";

  src = fetchurl {
    url = "http://download.dnscrypt.org/dnscrypt-proxy/${name}.tar.bz2";
    sha256 = "0zfw9vi9qbsc55awncyigqfqp25v5adqk6jpg1jdfkmbqqfykk70";
  };

  configureFlags = ''
    ${stdenv.lib.optionalString stdenv.isLinux "--with-systemd"}
  '';

  buildInputs = [ pkgconfig libsodium ] ++ stdenv.lib.optional stdenv.isLinux systemd;

  meta = {
    description = "A tool for securing communications between a client and a DNS resolver";
    homepage = http://dnscrypt.org/;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ joachifm jgeerds ];
    platforms = stdenv.lib.platforms.all;
  };
}
