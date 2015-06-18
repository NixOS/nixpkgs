{ stdenv, fetchpatch, fetchurl, lib, openssl, pkgconfig, libnl
, dbus_libs ? null, readline ? null, pcsclite ? null
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "2.4";

  name = "wpa_supplicant-${version}";

  src = fetchurl {
    url = "http://hostap.epitest.fi/releases/${name}.tar.gz";
    sha256 = "08li21q1wjn5chrv289w666il9ah1w419y3dkq2rl4wnq0rci385";
  };

  # TODO: Patch epoll so that the dbus actually responds
  # TODO: Figure out how to get privsep working, currently getting SIGBUS
  extraConfig = ''
    CONFIG_LIBNL32=y
    CONFIG_EAP_FAST=y
    CONFIG_EAP_PWD=y
    CONFIG_EAP_PAX=y
    CONFIG_EAP_SAKE=y
    CONFIG_EAP_GPSK=y
    CONFIG_EAP_GPSK_SHA256=y
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
    CONFIG_TLSV12=y
    CONFIG_IEEE80211R=y
    CONFIG_DEBUG_SYSLOG=y
    #CONFIG_PRIVSEP=y
    CONFIG_IEEE80211N=y
    CONFIG_IEEE80211AC=y
    CONFIG_INTERNETWORKING=y
    CONFIG_HS20=y
    CONFIG_P2P=y
    CONFIG_TDLS=y
  '' + optionalString (pcsclite != null) ''
    CONFIG_EAP_SIM=y
    CONFIG_EAP_AKA=y
    CONFIG_EAP_AKA_PRIME=y
    CONFIG_PCSC=y
  '' + optionalString (dbus_libs != null) ''
    CONFIG_CTRL_IFACE_DBUS=y
    CONFIG_CTRL_IFACE_DBUS_NEW=y
    CONFIG_CTRL_IFACE_DBUS_INTRO=y
  '' + (if readline != null then ''
    CONFIG_READLINE=y
  '' else ''
    CONFIG_WPA_CLI_EDIT=y
  '');

  preBuild = ''
    cd wpa_supplicant
    cp -v defconfig .config
    echo "$extraConfig" >> .config
    cat -n .config
    substituteInPlace Makefile --replace /usr/local $out
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE \
      -I$(echo "${libnl}"/include/libnl*/) \
      -I${pcsclite}/include/PCSC/"
  '';

  buildInputs = [ openssl libnl dbus_libs readline pcsclite ];

  nativeBuildInputs = [ pkgconfig ];

  patches = [
    ./0001-P2P-Validate-SSID-element-length-before-copying-it-C.patch
    ./build-fix.patch
    (fetchpatch {
      name = "p2p-fix.patch";
      url = "http://w1.fi/cgit/hostap/patch/?id=8a78e227df1ead19be8e12a4108e448887e64d6f";
      sha256 = "1k2mcq1jv8xzi8061ixcz6j56n4i8wbq0vxcvml204q1syy2ika0";
    })
    (fetchpatch {
      url = http://w1.fi/security/2015-4/0001-EAP-pwd-peer-Fix-payload-length-validation-for-Commi.patch;
      sha256 = "1cg4r638s4m9ar9lmzm534y657ppcm8bl1h363kjnng1zbzh8rfb";
    })
    (fetchpatch {
      url = http://w1.fi/security/2015-4/0002-EAP-pwd-server-Fix-payload-length-validation-for-Com.patch;
      sha256 = "0ky850rg1k9lwd1p4wzyvl2dpi5g7k1mwx1ndjclp4x7bshb6w79";
    })
    (fetchpatch {
      url = http://w1.fi/security/2015-4/0003-EAP-pwd-peer-Fix-Total-Length-parsing-for-fragment-r.patch;
      sha256 = "0hicw3vk1khk849xil75ckrg1xzbwcva7g01kp0lvab34dwhryy7";
    })
    (fetchpatch {
      url = http://w1.fi/security/2015-4/0004-EAP-pwd-server-Fix-Total-Length-parsing-for-fragment.patch;
      sha256 = "18d5r3zbwz96n4zzj9r27cv4kvc09zkj9x0p6qji68h8k2pcazxd";
    })
    (fetchpatch {
      url = http://w1.fi/security/2015-4/0005-EAP-pwd-peer-Fix-asymmetric-fragmentation-behavior.patch;
      sha256 = "1ndzyfpnxpvryiqal4kdic02kg9dgznh65kaqydaqqfj3rbjdqip";
    })
  ];

  postInstall = ''
    # Copy the wpa_priv binary which is not installed
    mkdir -p $out/bin
    cp -v wpa_priv $out/bin

    mkdir -p $out/share/man/man5 $out/share/man/man8
    cp -v "doc/docbook/"*.5 $out/share/man/man5/
    cp -v "doc/docbook/"*.8 $out/share/man/man8/
    mkdir -p $out/etc/dbus-1/system.d $out/share/dbus-1/system-services $out/etc/systemd/system
    cp -v "dbus/"*service $out/share/dbus-1/system-services
    sed -e "s@/sbin/wpa_supplicant@$out&@" -i "$out/share/dbus-1/system-services/"*
    cp -v dbus/dbus-wpa_supplicant.conf $out/etc/dbus-1/system.d
    cp -v "systemd/"*.service $out/etc/systemd/system
  '';

  meta = with stdenv.lib; {
    homepage = http://hostap.epitest.fi/wpa_supplicant/;
    description = "A tool for connecting to WPA and WPA2-protected wireless networks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marcweber urkud wkennington ];
    platforms = platforms.linux;
  };
}
