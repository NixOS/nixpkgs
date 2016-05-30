{ stdenv, fetchurl, gmp, pkgconfig, python, autoreconfHook
, curl, trousers, sqlite, iptables, libxml2, openresolv
, ldns, unbound, pcsclite, openssl
, enableTNC ? false }:

stdenv.mkDerivation rec {
  name = "strongswan-${version}";
  version = "5.4.0";

  src = fetchurl {
    url = "http://download.strongswan.org/${name}.tar.bz2";
    sha256 = "12dy7dfwblihrc2zs0fdvyimvgi2g5mvgh0ksjkxi73axam8ya7q";
  };

  dontPatchELF = true;

  buildInputs =
    [ gmp pkgconfig python autoreconfHook iptables ldns unbound openssl pcsclite ]
    ++ stdenv.lib.optionals enableTNC [ curl trousers sqlite libxml2 ];

  patches = [
    ./ext_auth-path.patch
    ./firewall_defaults.patch
    ./updown-path.patch
  ];

  postPatch = ''
    substituteInPlace src/libcharon/plugins/resolve/resolve_handler.c --replace "/sbin/resolvconf" "${openresolv}/sbin/resolvconf"
    '';

  configureFlags =
    [ "--enable-swanctl" "--enable-cmd"
      "--enable-farp" "--enable-dhcp"
      "--enable-eap-sim" "--enable-eap-sim-file" "--enable-eap-simaka-pseudonym"
      "--enable-eap-simaka-reauth" "--enable-eap-identity" "--enable-eap-md5"
      "--enable-eap-gtc" "--enable-eap-aka" "--enable-eap-aka-3gpp2"
      "--enable-eap-mschapv2" "--enable-xauth-eap" "--enable-ext-auth"
      "--enable-forecast" "--enable-connmark" "--enable-acert"
      "--enable-pkcs11" "--enable-eap-sim-pcsc" "--enable-dnscert" "--enable-unbound"
      "--enable-aesni" "--enable-af-alg" "--enable-rdrand" ]
    ++ stdenv.lib.optional (stdenv.system == "i686-linux") "--enable-padlock" 
    ++ stdenv.lib.optionals enableTNC [
         "--disable-gmp" "--disable-aes" "--disable-md5" "--disable-sha1" "--disable-sha2" "--disable-fips-prf"
         "--enable-curl" "--enable-openssl"
         "--enable-eap-tnc" "--enable-eap-ttls" "--enable-eap-dynamic" "--enable-tnccs-20"
         "--enable-tnc-imc" "--enable-imc-os" "--enable-imc-attestation"
         "--enable-tnc-imv" "--enable-imv-attestation"
         "--enable-tnc-ifmap" "--enable-tnc-imc" "--enable-tnc-imv"
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
