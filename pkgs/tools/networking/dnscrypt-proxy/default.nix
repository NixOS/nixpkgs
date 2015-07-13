{ stdenv, fetchurl, libsodium, pkgconfig, systemd }:

stdenv.mkDerivation rec {
  name = "dnscrypt-proxy-${version}";
  version = "1.5.0";

  src = fetchurl {
    url = "http://download.dnscrypt.org/dnscrypt-proxy/${name}.tar.bz2";
    sha256 = "1cp3ivxngrihil6i7b659d39v9v6iwjs16s2kj9wz1anzyx0j6nx";
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
