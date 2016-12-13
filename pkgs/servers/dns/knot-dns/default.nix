{ stdenv, fetchurl, pkgconfig, gnutls, jansson, liburcu, lmdb, libcap_ng, libidn
, systemd, nettle, libedit }:

# Note: ATM only the libraries have been tested in nixpkgs.
stdenv.mkDerivation rec {
  name = "knot-dns-${version}";
  version = "2.3.3";

  src = fetchurl {
    url = "http://secure.nic.cz/files/knot-dns/knot-${version}.tar.xz";
    sha256 = "a929bce3b957a81776b1db7b43b0e4473339bf16be8dbba5abb4b0593bf43c94";
  };

  outputs = [ "bin" "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gnutls jansson liburcu lmdb libcap_ng libidn
    systemd nettle libedit
    # without sphinx &al. for developer documentation
  ];

  enableParallelBuilding = true;

  CFLAGS = [ "-DNDEBUG" ];

  #doCheck = true; problems in combination with dynamic linking

  postInstall = ''rm -r "$out"/var'';

  meta = with stdenv.lib; {
    description = "Authoritative-only DNS server from .cz domain registry";
    homepage = https://knot-dns.cz;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}

