{ lib, stdenv, fetchurl, fetchpatch, openssl, pkg-config, libnl
, dbus, readline ? null, pcsclite ? null
}:

with lib;
stdenv.mkDerivation rec {
  version = "2.9";

  pname = "wpa_supplicant";

  src = fetchurl {
    url = "https://w1.fi/releases/${pname}-${version}.tar.gz";
    sha256 = "05qzak1mssnxcgdrafifxh9w86a4ha69qabkg4bsigk499xyxggw";
  };

  patches = [
    (fetchurl {
      name = "CVE-2019-16275.patch";
      url = "https://w1.fi/security/2019-7/0001-AP-Silently-ignore-management-frame-from-unexpected-.patch";
      sha256 = "15xjyy7crb557wxpx898b5lnyblxghlij0xby5lmj9hpwwss34dz";
    })
    (fetchpatch {
      # Expose OWE key management capability over DBus, remove >= 2.10
      name = "dbus-Export-OWE-capability-and-OWE-BSS-key_mgmt.patch";
      url = "https://w1.fi/cgit/hostap/patch/?id=7800725afb27397f7d6033d4969e2aeb61af4737";
      sha256 = "0c1la7inf4m5y9gzdjjdnhpkx32pm8vi6m5knih8p77q4mbrdgg8";
    })
    # P2P: Fix copying of secondary device types for P2P group client (https://w1.fi/security/2020-2/)
    (fetchurl {
      name = "CVE-2021-0326.patch";
      url = "https://w1.fi/security/2020-2/0001-P2P-Fix-copying-of-secondary-device-types-for-P2P-gr.patch";
      sha256 = "19f4hx0p547mdx8y8arb3vclwyy4w9c8a6a40ryj7q33730mrmn4";
    })
    # P2P: Fix a corner case in peer addition based on PD Request (https://w1.fi/security/2021-1/)
    (fetchurl {
      name = "CVE-2021-27803.patch";
      url = "https://w1.fi/security/2021-1/0001-P2P-Fix-a-corner-case-in-peer-addition-based-on-PD-R.patch";
      sha256 = "04cnds7hmbqc44jasabjvrdnh66i5hwvk2h2m5z94pmgbzncyh3z";
    })
  ];

  # TODO: Patch epoll so that the dbus actually responds
  # TODO: Figure out how to get privsep working, currently getting SIGBUS
  extraConfig = ''
    CONFIG_AP=y
    CONFIG_LIBNL32=y
    CONFIG_EAP_FAST=y
    CONFIG_EAP_PWD=y
    CONFIG_EAP_PAX=y
    CONFIG_EAP_SAKE=y
    CONFIG_EAP_GPSK=y
    CONFIG_EAP_GPSK_SHA256=y
    CONFIG_OWE=y
    CONFIG_WPS=y
    CONFIG_WPS_ER=y
    CONFIG_WPS_NFS=y
    CONFIG_EAP_IKEV2=y
    CONFIG_EAP_EKE=y
    CONFIG_HT_OVERRIDES=y
    CONFIG_VHT_OVERRIDES=y
    CONFIG_ELOOP=eloop
    #CONFIG_ELOOP_EPOLL=y
    CONFIG_L2_PACKET=linux
    CONFIG_IEEE80211W=y
    CONFIG_TLS=openssl
    CONFIG_TLSV11=y
    #CONFIG_TLSV12=y see #8332
    CONFIG_IEEE80211R=y
    CONFIG_DEBUG_SYSLOG=y
    #CONFIG_PRIVSEP=y
    CONFIG_IEEE80211N=y
    CONFIG_IEEE80211AC=y
    CONFIG_INTERNETWORKING=y
    CONFIG_HS20=y
    CONFIG_P2P=y
    CONFIG_TDLS=y
    CONFIG_BGSCAN_SIMPLE=y
  '' + optionalString (pcsclite != null) ''
    CONFIG_EAP_SIM=y
    CONFIG_EAP_AKA=y
    CONFIG_EAP_AKA_PRIME=y
    CONFIG_PCSC=y
  '' + optionalString (dbus != null) ''
    CONFIG_CTRL_IFACE_DBUS=y
    CONFIG_CTRL_IFACE_DBUS_NEW=y
    CONFIG_CTRL_IFACE_DBUS_INTRO=y
  '' + (if readline != null then ''
    CONFIG_READLINE=y
  '' else ''
    CONFIG_WPA_CLI_EDIT=y
  '');

  preBuild = ''
    for manpage in wpa_supplicant/doc/docbook/wpa_supplicant.conf* ; do
      substituteInPlace "$manpage" --replace /usr/share/doc $out/share/doc
    done
    cd wpa_supplicant
    cp -v defconfig .config
    echo "$extraConfig" >> .config
    cat -n .config
    substituteInPlace Makefile --replace /usr/local $out
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE \
      -I$(echo "${lib.getDev libnl}"/include/libnl*/) \
      -I${lib.getDev pcsclite}/include/PCSC/"
  '';

  buildInputs = [ openssl libnl dbus readline pcsclite ];

  nativeBuildInputs = [ pkg-config ];

  postInstall = ''
    mkdir -p $out/share/man/man5 $out/share/man/man8
    cp -v "doc/docbook/"*.5 $out/share/man/man5/
    cp -v "doc/docbook/"*.8 $out/share/man/man8/

    mkdir -p $out/share/dbus-1/system.d $out/share/dbus-1/system-services $out/etc/systemd/system
    cp -v "dbus/"*service $out/share/dbus-1/system-services
    sed -e "s@/sbin/wpa_supplicant@$out&@" -i "$out/share/dbus-1/system-services/"*
    cp -v dbus/dbus-wpa_supplicant.conf $out/share/dbus-1/system.d
    cp -v "systemd/"*.service $out/etc/systemd/system

    rm $out/share/man/man8/wpa_priv.8
    install -Dm444 wpa_supplicant.conf $out/share/doc/wpa_supplicant/wpa_supplicant.conf.example
  '';

  meta = with lib; {
    homepage = "https://w1.fi/wpa_supplicant/";
    description = "A tool for connecting to WPA and WPA2-protected wireless networks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.linux;
  };
}
