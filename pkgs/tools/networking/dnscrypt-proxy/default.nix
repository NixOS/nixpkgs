{ stdenv, fetchurl, pkgconfig, libsodium, systemd }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "dnscrypt-proxy-${version}";
  version = "1.9.0";

  src = fetchurl {
    url = "https://download.dnscrypt.org/dnscrypt-proxy/${name}.tar.bz2";
    sha256 = "0v5rsn9zdakzn6rcf2qhjqfd2y4h8q0hj4xr5hwhvaskg213rsyp";
  };

  configureFlags = optional stdenv.isLinux "--with-systemd";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libsodium ] ++ optional stdenv.isLinux systemd;

  postInstall = ''
    # Previous versions required libtool files to load plugins; they are
    # now strictly optional.
    rm $out/lib/dnscrypt-proxy/*.la

    # The installation ends up copying the same sample configuration
    # into $out/etc twice, with the expectation that one of them will be
    # edited by the user.  Since we can't modify the file, it makes more
    # sense to move only a single copy to the doc directory.
    mkdir -p $out/share/doc/dnscrypt-proxy
    mv $out/etc/dnscrypt-proxy.conf.example $out/share/doc/dnscrypt-proxy/
    rm -rf $out/etc
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
