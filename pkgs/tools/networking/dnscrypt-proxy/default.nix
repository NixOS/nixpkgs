{ stdenv, fetchurl, libsodium, pkgconfig, systemd }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "dnscrypt-proxy-${version}";
  version = "1.6.1";

  src = fetchurl {
    url = "https://download.dnscrypt.org/dnscrypt-proxy/${name}.tar.bz2";
    sha256 = "16lif3qhyfjpgg54vjlwpslxk90akmbhlpnn1szxm628bmpw6nl9";
  };

  configureFlags = ''
    ${optionalString stdenv.isLinux "--with-systemd"}
  '';

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libsodium ] ++ optional stdenv.isLinux systemd;

  outputs = [ "out" "man" ];

  meta = {
    description = "A tool for securing communications between a client and a DNS resolver";
    homepage = https://dnscrypt.org/;
    license = licenses.isc;
    maintainers = with maintainers; [ joachifm jgeerds ];
    # upstream claims OSX support, but Hydra fails
    platforms = with platforms; allBut [ darwin ];
  };
}
