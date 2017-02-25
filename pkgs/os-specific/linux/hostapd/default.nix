{ stdenv, fetchurl, pkgconfig, libnl, openssl, sqlite ? null }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "hostapd-${version}";
  version = "2.6";

  src = fetchurl {
    url = "http://hostap.epitest.fi/releases/${name}.tar.gz";
    sha256 = "0z8ilypad82q3l6q6kbv6hczvhjn8k63j8051x5yqfyjq686nlh1";
  };

  patches = [
    (fetchurl {
      url = "http://w1.fi/cgit/hostap/patch/?id=0d42179e1246f996d334c8bd18deca469fdb1add";
      sha256 = "0w5n3ypwavq5zlyfxpcyvbaf96g59xkwbw9xwpjyzb7h5j264615";
    })
    (fetchurl {
      url = "http://w1.fi/cgit/hostap/patch/?id=df426738fb212d62b132d9bb447f0128194e00ab";
      sha256 = "0ps2prjijlcgv1i97xb5ypw840dhkc7ja1aw8zhlbrap7pbgi1mm";
    })
    (fetchurl {
      url = "http://w1.fi/cgit/hostap/patch/?id=b70d508c50e8e2d2b8fb96ae44ae10f84cf0c1ae";
      sha256 = "0pslmsbay2cy1k07w1mdcr0b8w059jkrqrr9zi1aljvkm3vbwhj1";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libnl openssl sqlite ];

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
  '' + optionalString (sqlite != null) ''
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

  meta = {
    homepage = http://hostap.epitest.fi;
    repositories.git = git://w1.fi/hostap.git;
    description = "A user space daemon for access point and authentication servers";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom wkennington ];
    platforms = platforms.linux;
  };
}
