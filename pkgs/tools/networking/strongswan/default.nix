{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  perl,
  gperf,
  bison,
  flex,
  gmp,
  python3,
  iptables,
  ldns,
  unbound,
  openssl,
  pcsclite,
  glib,
  openresolv,
  systemd,
  pam,
  curl,
  enableTNC ? false,
  trousers,
  sqlite,
  libxml2,
  enableNetworkManager ? false,
  networkmanager,
  darwin,
  nixosTests,
}:

# Note on curl support: If curl is built with gnutls as its backend, the
# strongswan curl plugin may break.
# See https://wiki.strongswan.org/projects/strongswan/wiki/Curl for more info.

stdenv.mkDerivation rec {
  pname = "strongswan";
  version = "5.9.14"; # Make sure to also update <nixpkgs/nixos/modules/services/networking/strongswan-swanctl/swanctl-params.nix> when upgrading!

  src = fetchFromGitHub {
    owner = "strongswan";
    repo = "strongswan";
    rev = version;
    hash = "sha256-qFM7ErfqiDlUsZdGXJQVW3nJoh+I6tEdKRwzrKteRVY=";
  };

  dontPatchELF = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    perl
    gperf
    bison
    flex
  ];
  buildInputs =
    [
      curl
      gmp
      python3
      ldns
      unbound
      openssl
      pcsclite
    ]
    ++ lib.optionals enableTNC [
      trousers
      sqlite
      libxml2
    ]
    ++ lib.optionals stdenv.isLinux [
      systemd.dev
      pam
      iptables
    ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ SystemConfiguration ])
    ++ lib.optionals enableNetworkManager [
      networkmanager
      glib
    ];

  patches = [
    ./ext_auth-path.patch
    ./firewall_defaults.patch
    ./updown-path.patch
  ];

  postPatch = lib.optionalString stdenv.isLinux ''
    # glibc-2.26 reorganized internal includes
    sed '1i#include <stdint.h>' -i src/libstrongswan/utils/utils/memory.h

    substituteInPlace src/libcharon/plugins/resolve/resolve_handler.c --replace "/sbin/resolvconf" "${openresolv}/sbin/resolvconf"
  '';

  configureFlags =
    [
      "--enable-swanctl"
      "--enable-cmd"
      "--enable-openssl"
      "--enable-eap-sim"
      "--enable-eap-sim-file"
      "--enable-eap-simaka-pseudonym"
      "--enable-eap-simaka-reauth"
      "--enable-eap-identity"
      "--enable-eap-md5"
      "--enable-eap-gtc"
      "--enable-eap-aka"
      "--enable-eap-aka-3gpp2"
      "--enable-eap-mschapv2"
      "--enable-eap-radius"
      "--enable-xauth-eap"
      "--enable-ext-auth"
      "--enable-acert"
      "--enable-pkcs11"
      "--enable-eap-sim-pcsc"
      "--enable-dnscert"
      "--enable-unbound"
      "--enable-chapoly"
      "--enable-curl"
    ]
    ++ lib.optionals stdenv.isLinux [
      "--enable-farp"
      "--enable-dhcp"
      "--enable-systemd"
      "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
      "--enable-xauth-pam"
      "--enable-forecast"
      "--enable-connmark"
      "--enable-af-alg"
    ]
    ++ lib.optionals stdenv.isx86_64 [
      "--enable-aesni"
      "--enable-rdrand"
    ]
    ++ lib.optional (stdenv.hostPlatform.system == "i686-linux") "--enable-padlock"
    ++ lib.optionals enableTNC [
      "--disable-gmp"
      "--disable-aes"
      "--disable-md5"
      "--disable-sha1"
      "--disable-sha2"
      "--disable-fips-prf"
      "--enable-eap-tnc"
      "--enable-eap-ttls"
      "--enable-eap-dynamic"
      "--enable-tnccs-20"
      "--enable-tnc-imc"
      "--enable-imc-os"
      "--enable-imc-attestation"
      "--enable-tnc-imv"
      "--enable-imv-attestation"
      "--enable-tnc-ifmap"
      "--enable-tnc-imc"
      "--enable-tnc-imv"
      "--with-tss=trousers"
      "--enable-aikgen"
      "--enable-sqlite"
    ]
    ++ lib.optionals enableNetworkManager [
      "--enable-nm"
      "--with-nm-ca-dir=/etc/ssl/certs"
    ]
    # Taken from: https://wiki.strongswan.org/projects/strongswan/wiki/MacOSX
    ++ lib.optionals stdenv.isDarwin [
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

  NIX_LDFLAGS = lib.optionalString stdenv.cc.isGNU "-lgcc_s";

  passthru.tests = { inherit (nixosTests) strongswan-swanctl; };

  meta = with lib; {
    description = "OpenSource IPsec-based VPN Solution";
    homepage = "https://www.strongswan.org";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
