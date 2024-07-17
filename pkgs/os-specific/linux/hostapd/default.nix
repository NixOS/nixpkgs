{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  libnl,
  openssl,
  nixosTests,
  sqlite ? null,
}:

stdenv.mkDerivation rec {
  pname = "hostapd";
  version = "2.10";

  src = fetchurl {
    url = "https://w1.fi/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-IG58eZtnhXLC49EgMCOHhLxKn4IyOwFWtMlGbxSYkV0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libnl
    openssl
    sqlite
  ];

  patches = [
    (fetchurl {
      # Note: fetchurl seems to be unhappy with openwrt git
      # server's URLs containing semicolons. Using the github mirror instead.
      url = "https://raw.githubusercontent.com/openwrt/openwrt/eefed841b05c3cd4c65a78b50ce0934d879e6acf/package/network/services/hostapd/patches/300-noscan.patch";
      sha256 = "08p5frxhpq1rp2nczkscapwwl8g9nc4fazhjpxic5bcbssc3sb00";
    })

    # Backported security patches for CVE-2024-3596 (https://blastradius.fail),
    # these can be removed when updating to 2.11.

    # RADIUS: Allow Message-Authenticator attribute as the first attribute
    (fetchpatch {
      url = "https://w1.fi/cgit/hostap/patch/?id=adac846bd0e258a0aa50750bbd2b411fa0085c46";
      hash = "sha256-1jfSeVGL5tyZn8F2wpQ7KwaQaEKWsCOW/bavovMcdz4=";
    })

    # RADIUS server: Place Message-Authenticator attribute as the first one
    (fetchpatch {
      url = "https://w1.fi/cgit/hostap/patch/?id=54abb0d3cf35894e7d86e3f7555e95b106306803";
      hash = "sha256-fVhQlOVETttVf1M9iKrXJrv7mxpxSjCt3w8kndRal08=";
    })

    # hostapd: Move Message-Authenticator attribute to be the first one in req
    (fetchpatch {
      url = "https://w1.fi/cgit/hostap/patch/?id=37fe8e48ab44d44fe3cf5dd8f52cb0a10be0cd17";
      hash = "sha256-3eoAkXhieO3f0R5PTlH6g5wcgo/aLQN6XcPSITGgciE=";
    })

    # RADIUS DAS: Move Message-Authenticator attribute to be the first one
    (fetchpatch {
      url = "https://w1.fi/cgit/hostap/patch/?id=f54157077f799d84ce26bed6ad6b01c4a16e31cf";
      hash = "sha256-dcaghKbKNFVSN6ONNaFt1s0S35mkqox2aykiExEXyPQ=";
    })

    # Require Message-Authenticator in Access-Reject even without EAP-Message
    (fetchpatch {
      url = "https://w1.fi/cgit/hostap/patch/?id=934b0c3a45ce0726560ccefbd992a9d385c36385";
      hash = "sha256-9GquP/+lsghF81nMhOuRwlSz/pEnmk+mSex8aM3/qdA=";
    })

    # RADIUS: Require Message-Authenticator attribute in MAC ACL cases
    #(fetchpatch {
    #  url = "https://w1.fi/cgit/hostap/patch/?id=58097123ec5ea6f8276b38cb9b07669ec368a6c1";
    #  hash = "sha256-mW+PAeAkNcrlFPsjxLvZ/1Smq6H6KXq5Le3HuLA2KKw=";
    #})
    # Needed to be fixed to apply correctly:
    ./0007-RADIUS-Require-Message-Authenticator-attribute-in-MA.patch

    # RADIUS: Check Message-Authenticator if it is present even if not required
    (fetchpatch {
      url = "https://w1.fi/cgit/hostap/patch/?id=f302d9f9646704cce745734af21d540baa0da65f";
      hash = "sha256-6i0cq5YBm2w03yMrdYGaEqe1dTsmokZWOs4WPFX36qo=";
    })
  ];

  outputs = [
    "out"
    "man"
  ];

  # Based on hostapd's defconfig. Only differences are tracked.
  extraConfig =
    ''
      # Use epoll(7) instead of select(2) on linux
      CONFIG_ELOOP_EPOLL=y

      # Drivers
      CONFIG_DRIVER_WIRED=y
      CONFIG_DRIVER_NONE=y

      # Integrated EAP server
      CONFIG_EAP_SIM=y
      CONFIG_EAP_AKA=y
      CONFIG_EAP_AKA_PRIME=y
      CONFIG_EAP_PAX=y
      CONFIG_EAP_PSK=y
      CONFIG_EAP_PWD=y
      CONFIG_EAP_SAKE=y
      CONFIG_EAP_GPSK=y
      CONFIG_EAP_GPSK_SHA256=y
      CONFIG_EAP_FAST=y
      CONFIG_EAP_IKEV2=y
      CONFIG_EAP_TNC=y
      CONFIG_EAP_EKE=y

      CONFIG_TLS=openssl
      CONFIG_TLSV11=y
      CONFIG_TLSV12=y

      CONFIG_SAE=y
      CONFIG_SAE_PK=y

      CONFIG_OWE=y
      CONFIG_OCV=y

      # TKIP is considered insecure and upstream support will be removed in the future
      CONFIG_NO_TKIP=y

      # Misc
      CONFIG_RADIUS_SERVER=y
      CONFIG_MACSEC=y
      CONFIG_DRIVER_MACSEC_LINUX=y
      CONFIG_FULL_DYNAMIC_VLAN=y
      CONFIG_VLAN_NETLINK=y
      CONFIG_GETRANDOM=y
      CONFIG_INTERWORKING=y
      CONFIG_HS20=y
      CONFIG_FST=y
      CONFIG_FST_TEST=y
      CONFIG_ACS=y
      CONFIG_WNM=y
      CONFIG_MBO=y

      CONFIG_IEEE80211R=y
      CONFIG_IEEE80211W=y
      CONFIG_IEEE80211N=y
      CONFIG_IEEE80211AC=y
      CONFIG_IEEE80211AX=y
    ''
    + lib.optionalString (sqlite != null) ''
      CONFIG_SQLITE=y
    '';

  passAsFile = [ "extraConfig" ];

  configurePhase = ''
    cd hostapd
    cp -v defconfig .config
    cat $extraConfigPath >> .config
    cat -n .config
    substituteInPlace Makefile --replace /usr/local $out
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags libnl-3.0)"
  '';

  preInstall = "mkdir -p $out/bin";
  postInstall = ''
    install -vD hostapd.8 -t $man/share/man/man8
    install -vD hostapd_cli.1 -t $man/share/man/man1
  '';

  passthru.tests = {
    inherit (nixosTests) wpa_supplicant;
  };

  meta = with lib; {
    homepage = "https://w1.fi/hostapd/";
    description = "A user space daemon for access point and authentication servers";
    license = licenses.gpl2;
    maintainers = with maintainers; [ oddlama ];
    platforms = platforms.linux;
  };
}
