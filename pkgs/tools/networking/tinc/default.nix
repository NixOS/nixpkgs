{
  lib,
  stdenv,
  fetchurl,
  lzo,
  openssl,
  zlib,
}:

stdenv.mkDerivation rec {
  version = "1.0.36";
  pname = "tinc";

  src = fetchurl {
    url = "https://www.tinc-vpn.org/packages/tinc-${version}.tar.gz";
    sha256 = "021i2sl2mjscbm8g59d7vs74iw3gf0m48wg7w3zhwj6czarkpxs0";
  };

  buildInputs = [
    lzo
    openssl
    zlib
  ];

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  meta = {
    description = "VPN daemon with full mesh routing";
    longDescription = ''
      tinc is a Virtual Private Network (VPN) daemon that uses tunnelling and
      encryption to create a secure private network between hosts on the
      Internet.  It features full mesh routing, as well as encryption,
      authentication, compression and ethernet bridging.
    '';
    homepage = "http://www.tinc-vpn.org/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "tincd";
    platforms = lib.platforms.unix;
  };
}
