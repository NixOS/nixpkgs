{ stdenv, fetchurl, gmp, pkgconfig, python, autoreconfHook
, curl, trousers, sqlite, iptables, libxml2, openresolv
, ldns, unbound, pcsclite, openssl, systemd, pam
, enableTNC ? false }:

stdenv.mkDerivation rec {
  name = "strongswan-${version}";
  version = "5.5.3";

  src = fetchurl {
    url = "http://download.strongswan.org/${name}.tar.bz2";
    sha256 = "1m7qq0l5pwj1wy0f7h2b7msb1d98rx78z6xg27g0hiqpk6qm9sn5";
  };

  dontPatchELF = true;

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs =
    [ gmp python iptables ldns unbound openssl pcsclite ]
    ++ stdenv.lib.optionals enableTNC [ curl trousers sqlite libxml2 ]
    ++ stdenv.lib.optionals stdenv.isLinux [ systemd.dev pam ];

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
    '';

  preConfigure = ''
    configureFlagsArray+=("--with-systemdsystemunitdir=$out/etc/systemd/system")
  '';

  configureFlags =
    [ "--enable-swanctl" "--enable-cmd" "--enable-systemd"
      "--enable-farp" "--enable-dhcp"
      "--enable-eap-sim" "--enable-eap-sim-file" "--enable-eap-simaka-pseudonym"
      "--enable-eap-simaka-reauth" "--enable-eap-identity" "--enable-eap-md5"
      "--enable-eap-gtc" "--enable-eap-aka" "--enable-eap-aka-3gpp2"
      "--enable-eap-mschapv2" "--enable-xauth-eap" "--enable-ext-auth"
      "--enable-forecast" "--enable-connmark" "--enable-acert"
      "--enable-pkcs11" "--enable-eap-sim-pcsc" "--enable-dnscert" "--enable-unbound"
      "--enable-af-alg" "--enable-xauth-pam" ]
    ++ stdenv.lib.optional stdenv.isx86_64 [ "--enable-aesni" "--enable-rdrand" ]
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
