{ stdenv, fetchurl, libsodium, pkgconfig, systemd }:

stdenv.mkDerivation rec {
  name = "dnscrypt-proxy-${version}";
  version = "1.6.1";

  src = fetchurl {
    url = "http://download.dnscrypt.org/dnscrypt-proxy/${name}.tar.bz2";
    sha256 = "16lif3qhyfjpgg54vjlwpslxk90akmbhlpnn1szxm628bmpw6nl9";
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
