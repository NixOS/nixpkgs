{ stdenv, fetchurl, libsodium, pkgconfig, systemd }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "dnscrypt-proxy-${version}";
  version = "1.7.0";

  src = fetchurl {
    url = "https://download.dnscrypt.org/dnscrypt-proxy/${name}.tar.bz2";
    sha256 = "1qw2nib0d5ia8581lbdnjxgn9c7pf2qw8vhpnnh1wjcjj3gpgbqx";
  };

  configureFlags = optional stdenv.isLinux "--with-systemd";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libsodium ] ++ optional stdenv.isLinux systemd;

  outputs = [ "out" "man" ];

  meta = {
    description = "A tool for securing communications between a client and a DNS resolver";
    homepage = https://dnscrypt.org/;
    license = licenses.isc;
    maintainers = with maintainers; [ joachifm jgeerds ];
    # upstream claims OSX support, but Hydra fails
    platforms = with platforms; allBut darwin;
  };
}
