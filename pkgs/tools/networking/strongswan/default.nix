{ stdenv, fetchurl, gmp, pkgconfig, python, autoreconfHook
, curl, trousers, sqlite
, enableTNC ? false }:

stdenv.mkDerivation rec {
  name = "strongswan-5.3.2";

  src = fetchurl {
    url = "http://download.strongswan.org/${name}.tar.bz2";
    sha256 = "09gjrd5f8iykh926y35blxlm2hlzpw15m847d8vc9ga29s6brad4";
  };

  dontPatchELF = true;

  buildInputs =
    [ gmp pkgconfig python autoreconfHook ]
    ++ stdenv.lib.optionals enableTNC [ curl trousers sqlite ];

  patches = [
    ./ext_auth-path.patch
    ./firewall_defaults.patch
    ./updown-path.patch
  ];

  configureFlags =
    [ "--enable-swanctl" "--enable-cmd" ]
    ++ stdenv.lib.optionals enableTNC [
         "--disable-gmp" "--disable-aes" "--disable-md5" "--disable-sha1" "--disable-sha2" "--disable-fips-prf"
         "--enable-curl" "--enable-openssl" "--enable-eap-identity" "--enable-eap-md5" "--enable-eap-mschapv2"
         "--enable-eap-tnc" "--enable-eap-ttls" "--enable-eap-dynamic" "--enable-tnccs-20"
         "--enable-tnc-imc" "--enable-imc-os" "--enable-imc-attestation"
         "--enable-tnc-imv" "--enable-imv-attestation"
         "--with-tss=trousers"
         "--enable-aikgen"
         "--enable-sqlite" ];

  NIX_LDFLAGS = "-lgcc_s" ;

  meta = {
    description = "OpenSource IPsec-based VPN Solution";
    homepage = https://www.strongswan.org;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
  };
}
