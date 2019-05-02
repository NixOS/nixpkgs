{ stdenv, fetchurl, substituteAll
, pkgconfig, autoreconfHook
, gmp, python, iptables, ldns, unbound, openssl, pcsclite
, openresolv
, systemd, pam
, curl
, kmod
, enableTNC            ? false, trousers, sqlite, libxml2
, enableNetworkManager ? false, networkmanager
, libpcap
, darwin
}:

# Note on curl support: If curl is built with gnutls as its backend, the
# strongswan curl plugin may break.
# See https://wiki.strongswan.org/projects/strongswan/wiki/Curl for more info.

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "strongswan-${version}";
  version = "5.7.2";

  src = fetchurl {
    url = "https://download.strongswan.org/${name}.tar.bz2";
    sha256 = "0w6cks42lvvyj5ivyhqyqxya48x93yzfpz281q3xmqicdskkp3ih";
  };

  dontPatchELF = true;

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs =
    [ curl gmp python ldns unbound openssl pcsclite ]
    ++ optionals enableTNC [ trousers sqlite libxml2 ]
    ++ optionals stdenv.isLinux [ systemd.dev pam iptables ]
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ SystemConfiguration ])
    ++ optionals enableNetworkManager [ networkmanager ];

  patches = [
    ./ext_auth-path.patch
    ./firewall_defaults.patch
    ./updown-path.patch
    (optional stdenv.isLinux (substituteAll {
      src = ./modprobe-path.patch;
      inherit kmod;
    }))
  ];

  postPatch = optionalString stdenv.isLinux ''
    # glibc-2.26 reorganized internal includes
    sed '1i#include <stdint.h>' -i src/libstrongswan/utils/utils/memory.h

    substituteInPlace src/libcharon/plugins/resolve/resolve_handler.c --replace "/sbin/resolvconf" "${openresolv}/sbin/resolvconf"
    '';

  configureFlags =
    [ "--enable-swanctl"
      "--enable-cmd"
      "--enable-openssl"
      "--enable-eap-sim" "--enable-eap-sim-file" "--enable-eap-simaka-pseudonym"
      "--enable-eap-simaka-reauth" "--enable-eap-identity" "--enable-eap-md5"
      "--enable-eap-gtc" "--enable-eap-aka" "--enable-eap-aka-3gpp2"
      "--enable-eap-mschapv2" "--enable-eap-radius" "--enable-xauth-eap" "--enable-ext-auth"
      "--enable-acert"
      "--enable-pkcs11" "--enable-eap-sim-pcsc" "--enable-dnscert" "--enable-unbound"
      "--enable-chapoly"
      "--enable-curl" ]
    ++ optionals stdenv.isLinux [
      "--enable-farp" "--enable-dhcp"
      "--enable-systemd" "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
      "--enable-xauth-pam"
      "--enable-forecast"
      "--enable-connmark"
      "--enable-af-alg" ]
    ++ optionals stdenv.isx86_64 [ "--enable-aesni" "--enable-rdrand" ]
    ++ optional (stdenv.hostPlatform.system == "i686-linux") "--enable-padlock"
    ++ optionals enableTNC [
         "--disable-gmp" "--disable-aes" "--disable-md5" "--disable-sha1" "--disable-sha2" "--disable-fips-prf"
         "--enable-eap-tnc" "--enable-eap-ttls" "--enable-eap-dynamic" "--enable-tnccs-20"
         "--enable-tnc-imc" "--enable-imc-os" "--enable-imc-attestation"
         "--enable-tnc-imv" "--enable-imv-attestation"
         "--enable-tnc-ifmap" "--enable-tnc-imc" "--enable-tnc-imv"
         "--with-tss=trousers"
         "--enable-aikgen"
         "--enable-sqlite" ]
    ++ optionals enableNetworkManager [
         "--enable-nm"
         "--with-nm-ca-dir=/etc/ssl/certs" ]
    # Taken from: https://wiki.strongswan.org/projects/strongswan/wiki/MacOSX
    ++ optionals stdenv.isDarwin [
      "--disable-systemd"
      "--disable-xauth-pam"
      "--disable-kernel-netlink"
      "--enable-kernel-pfkey"
      "--enable-kernel-pfroute"
      "--enable-kernel-libipsec"
      "--enable-osx-attr"
      "--disable-scripts"
    ];

  postInstall = ''
    # this is needed for l2tp
    echo "include /etc/ipsec.secrets" >> $out/etc/ipsec.secrets
  '';

  NIX_LDFLAGS = optionalString stdenv.cc.isGNU "-lgcc_s" ;

  meta = {
    description = "OpenSource IPsec-based VPN Solution";
    homepage = https://www.strongswan.org;
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
