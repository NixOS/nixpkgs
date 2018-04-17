{ stdenv, fetchurl
, pkgconfig, autoreconfHook
, gmp, python, iptables, ldns, unbound, openssl, pcsclite
, openresolv
, systemd, pam

, enableTNC            ? false, curl, trousers, sqlite, libxml2
, enableNetworkManager ? false, networkmanager
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "strongswan-${version}";
  version = "5.6.2";

  src = fetchurl {
    url = "http://download.strongswan.org/${name}.tar.bz2";
    sha256 = "14ifqay54brw2b2hbmm517bxw8bs9631d7jm4g139igkxcq0m9p0";
  };

  dontPatchELF = true;

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs =
    [ gmp python iptables ldns unbound openssl pcsclite ]
    ++ optionals enableTNC [ curl trousers sqlite libxml2 ]
    ++ optionals stdenv.isLinux [ systemd.dev pam ]
    ++ optionals enableNetworkManager [ networkmanager ];

  patches = [
    ./ext_auth-path.patch
    ./firewall_defaults.patch
    ./updown-path.patch
  ];

  postPatch = ''
    substituteInPlace src/libcharon/plugins/resolve/resolve_handler.c --replace "/sbin/resolvconf" "${openresolv}/sbin/resolvconf"

    # swanctl can be configured by files in SWANCTLDIR which defaults to
    # $out/etc/swanctl. Since that directory is in the nix store users can't
    # modify it. Ideally swanctl accepts a command line option for specifying
    # the configuration files. In the absence of that we patch swanctl to look
    # for configuration files in /etc/swanctl.
    substituteInPlace src/swanctl/swanctl.h --replace "SWANCTLDIR" "\"/etc/swanctl\""
    # glibc-2.26 reorganized internal includes
    sed '1i#include <stdint.h>' -i src/libstrongswan/utils/utils/memory.h
    '';

  preConfigure = ''
    configureFlagsArray+=("--with-systemdsystemunitdir=$out/etc/systemd/system")
  '';

  configureFlags =
    [ "--enable-swanctl" "--enable-cmd" "--enable-systemd"
      "--enable-farp" "--enable-dhcp"
      "--enable-openssl"
      "--enable-eap-sim" "--enable-eap-sim-file" "--enable-eap-simaka-pseudonym"
      "--enable-eap-simaka-reauth" "--enable-eap-identity" "--enable-eap-md5"
      "--enable-eap-gtc" "--enable-eap-aka" "--enable-eap-aka-3gpp2"
      "--enable-eap-mschapv2" "--enable-eap-radius" "--enable-xauth-eap" "--enable-ext-auth"
      "--enable-forecast" "--enable-connmark" "--enable-acert"
      "--enable-pkcs11" "--enable-eap-sim-pcsc" "--enable-dnscert" "--enable-unbound"
      "--enable-af-alg" "--enable-xauth-pam" "--enable-chapoly" ]
    ++ optionals stdenv.isx86_64 [ "--enable-aesni" "--enable-rdrand" ]
    ++ optional (stdenv.system == "i686-linux") "--enable-padlock"
    ++ optionals enableTNC [
         "--disable-gmp" "--disable-aes" "--disable-md5" "--disable-sha1" "--disable-sha2" "--disable-fips-prf"
         "--enable-curl"
         "--enable-eap-tnc" "--enable-eap-ttls" "--enable-eap-dynamic" "--enable-tnccs-20"
         "--enable-tnc-imc" "--enable-imc-os" "--enable-imc-attestation"
         "--enable-tnc-imv" "--enable-imv-attestation"
         "--enable-tnc-ifmap" "--enable-tnc-imc" "--enable-tnc-imv"
         "--with-tss=trousers"
         "--enable-aikgen"
         "--enable-sqlite" ]
    ++ optional enableNetworkManager "--enable-nm";

  postInstall = ''
    # this is needed for l2tp
    echo "include /etc/ipsec.secrets" >> $out/etc/ipsec.secrets
  '';

  NIX_LDFLAGS = "-lgcc_s" ;

  meta = {
    description = "OpenSource IPsec-based VPN Solution";
    homepage = https://www.strongswan.org;
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
