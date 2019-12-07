{ stdenv, fetchurl, pkgconfig, libnl, openssl, sqlite ? null }:

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
      sha256 = "04wg4yjc19wmwk6gia067z99gzzk9jacnwxh5wyia7k5wg71yj5k";})
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
    homepage = https://hostap.epitest.fi;
    repositories.git = git://w1.fi/hostap.git;
    description = "A user space daemon for access point and authentication servers";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom ninjatrappeur ];
    platforms = platforms.linux;
  };
}
