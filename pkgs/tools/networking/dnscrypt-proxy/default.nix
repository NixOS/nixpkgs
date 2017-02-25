{ stdenv, fetchurl, pkgconfig, libsodium, systemd }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "dnscrypt-proxy-${version}";
  version = "1.9.4";

  src = fetchurl {
    url = "https://download.dnscrypt.org/dnscrypt-proxy/${name}.tar.bz2";
    sha256 = "07piwsjczamwvdpv1585kg4awqakip51bwsm8nqi6bljww4agx7x";
  };

  configureFlags = optional stdenv.isLinux "--with-systemd";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libsodium ] ++ optional stdenv.isLinux systemd;

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
