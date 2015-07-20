{ stdenv, fetchurl, gmp, pkgconfig, python, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "strongswan-5.3.2";

  src = fetchurl {
    url = "http://download.strongswan.org/${name}.tar.bz2";
    sha256 = "09gjrd5f8iykh926y35blxlm2hlzpw15m847d8vc9ga29s6brad4";
  };

  dontPatchELF = true;

  buildInputs = [ gmp pkgconfig python autoreconfHook ];

  patches = [
    ./ext_auth-path.patch
    ./firewall_defaults.patch
    ./updown-path.patch
  ];

  configureFlags = [ "--enable-swanctl" "--enable-cmd" ];

  NIX_LDFLAGS = "-lgcc_s" ;

  meta = {
    description = "OpenSource IPsec-based VPN Solution";
    homepage = https://www.strongswan.org;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
  };
}
