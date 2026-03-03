{
  lib,
  stdenv,
  fetchurl,
  lzo,
  openssl,
  zlib,
}:

stdenv.mkDerivation rec {
  version = "1.0.37";
  pname = "tinc";

  src = fetchurl {
    url = "https://www.tinc-vpn.org/packages/tinc-${version}.tar.gz";
    sha256 = "sha256-9jt+IcMsTGN1dthfNr3SjqZ4taoX+tAkJ2Rd6jDlKsc=";
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

  #passthru.tests = { inherit (nixosTests) tinc; }; # test uses tinc_pre

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
