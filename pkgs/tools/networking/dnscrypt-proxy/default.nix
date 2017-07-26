{ stdenv, fetchurl, pkgconfig, libsodium, ldns, openssl, systemd }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "dnscrypt-proxy-${version}";
  version = "1.9.5";

  src = fetchurl {
    url = "https://download.dnscrypt.org/dnscrypt-proxy/${name}.tar.bz2";
    sha256 = "1dhvklr4dg2vlw108n11xbamacaryyg3dbrg629b76lp7685p7z8";
  };

  configureFlags = optional stdenv.isLinux "--with-systemd";

  nativeBuildInputs = [ pkgconfig ];

  # <ldns/ldns.h> depends on <openssl/ssl.h>
  buildInputs = [ libsodium openssl.dev ldns ] ++ optional stdenv.isLinux systemd;

  postInstall = ''
    # Previous versions required libtool files to load plugins; they are
    # now strictly optional.
    rm $out/lib/dnscrypt-proxy/*.la
  '';

  meta = {
    description = "A tool for securing communications between a client and a DNS resolver";
    homepage = https://dnscrypt.org/;
    license = licenses.isc;
    maintainers = with maintainers; [ joachifm jgeerds ];
    # upstream claims OSX support, but Hydra fails
    platforms = with platforms; allBut darwin;
  };
}
