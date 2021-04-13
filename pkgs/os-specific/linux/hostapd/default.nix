{ lib, stdenv, fetchurl, fetchpatch, pkgconfig, libnl, openssl, sqlite ? null }:

stdenv.mkDerivation rec {
  pname = "hostapd";
  version = "2.9";

  src = fetchurl {
    url = "https://w1.fi/releases/${pname}-${version}.tar.gz";
    sha256 = "1mrbvg4v7vm7mknf0n29mf88k3s4a4qj6r4d51wq8hmjj1m7s7c8";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libnl openssl sqlite ];

  patches = [
    (fetchurl {
      # Note: fetchurl seems to be unhappy with openwrt git
      # server's URLs containing semicolons. Using the github mirror instead.
      url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/300-noscan.patch";
      sha256 = "04wg4yjc19wmwk6gia067z99gzzk9jacnwxh5wyia7k5wg71yj5k";
    })
    # AP mode PMF disconnection protection bypass (CVE.2019-16275), can be removed >= 2.10
    # https://w1.fi/security/2019-7/
    (fetchurl {
      name = "CVE-2019-16275.patch";
      url = "https://w1.fi/security/2019-7/0001-AP-Silently-ignore-management-frame-from-unexpected-.patch";
      sha256 = "15xjyy7crb557wxpx898b5lnyblxghlij0xby5lmj9hpwwss34dz";
    })
    # Fixes for UPnP SUBSCRIBE misbehavior in hostapd WPS AP (CVE-2020-12695), can be removed >= 2.10
    # https://w1.fi/security/2020-1/
    (fetchurl {
      name = "CVE-2020-12695_0001-WPS-UPnP-Do-not-allow-event-subscriptions-with-URLs-.patch";
      url = "https://w1.fi/security/2020-1/0001-WPS-UPnP-Do-not-allow-event-subscriptions-with-URLs-.patch";
      sha256 = "1mrbhicqb34jlw1nid5hk2vnjbvfhvp7r5iblaj4l6vgc6fmp6id";
    })
    (fetchurl {
      name = "CVE-2020-12695_0002-WPS-UPnP-Fix-event-message-generation-using-a-long-U.patch";
      url = "https://w1.fi/security/2020-1/0002-WPS-UPnP-Fix-event-message-generation-using-a-long-U.patch";
      sha256 = "1pk08b06b24is50bis3rr56xjd3b5kxdcdk8bx39n9vna9db7zj9";
    })
    (fetchurl {
      name = "CVE-2020-12695_0003-WPS-UPnP-Handle-HTTP-initiation-failures-for-events-.patch";
      url = "https://w1.fi/security/2020-1/0003-WPS-UPnP-Handle-HTTP-initiation-failures-for-events-.patch";
      sha256 = "12npqp2skgrj934wwkqicgqksma0fxz09di29n1b5fm5i4njl8d8";
    })
    # In wpa_supplicant and hostapd 2.9, forging attacks may occur because AlgorithmIdentifier parameters are mishandled in tls/pkcs1.c and tls/x509v3.c.
    (fetchpatch {
      name = "CVE-2021-30004.patch";
      url = "https://w1.fi/cgit/hostap/patch/?id=a0541334a6394f8237a4393b7372693cd7e96f15";
      sha256 = "1gbhlz41x1ar1hppnb76pqxj6vimiypy7c4kq6h658637s4am3xg";
    })
  ];

  outputs = [ "out" "man" ];

  extraConfig = ''
    CONFIG_DRIVER_WIRED=y
    CONFIG_LIBNL32=y
    CONFIG_EAP_SIM=y
    CONFIG_EAP_AKA=y
    CONFIG_EAP_AKA_PRIME=y
    CONFIG_EAP_PAX=y
    CONFIG_EAP_PWD=y
    CONFIG_EAP_SAKE=y
    CONFIG_EAP_GPSK=y
    CONFIG_EAP_GPSK_SHA256=y
    CONFIG_EAP_FAST=y
    CONFIG_EAP_IKEV2=y
    CONFIG_EAP_TNC=y
    CONFIG_EAP_EKE=y
    CONFIG_RADIUS_SERVER=y
    CONFIG_IEEE80211R=y
    CONFIG_IEEE80211N=y
    CONFIG_IEEE80211AC=y
    CONFIG_FULL_DYNAMIC_VLAN=y
    CONFIG_VLAN_NETLINK=y
    CONFIG_TLS=openssl
    CONFIG_TLSV11=y
    CONFIG_TLSV12=y
    CONFIG_INTERNETWORKING=y
    CONFIG_HS20=y
    CONFIG_ACS=y
    CONFIG_GETRANDOM=y
  '' + stdenv.lib.optionalString (sqlite != null) ''
    CONFIG_SQLITE=y
  '';

  configurePhase = ''
    cd hostapd
    cp -v defconfig .config
    echo "$extraConfig" >> .config
    cat -n .config
    substituteInPlace Makefile --replace /usr/local $out
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags libnl-3.0)"
  '';

  preInstall = "mkdir -p $out/bin";
  postInstall = ''
    install -vD hostapd.8 -t $man/share/man/man8
    install -vD hostapd_cli.1 -t $man/share/man/man1
  '';

  meta = with stdenv.lib; {
    homepage = "https://hostap.epitest.fi";
    repositories.git = "git://w1.fi/hostap.git";
    description = "A user space daemon for access point and authentication servers";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom ninjatrappeur hexa ];
    platforms = platforms.linux;
  };
}
