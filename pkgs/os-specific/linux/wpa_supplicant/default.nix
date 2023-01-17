{ lib, stdenv, fetchurl, openssl, pkg-config, libnl
, nixosTests, wpa_supplicant_gui
, dbusSupport ? true, dbus
, withReadline ? true, readline
, withPcsclite ? true, pcsclite
, readOnlyModeSSIDs ? false
}:

stdenv.mkDerivation rec {
  version = "2.10";

  pname = "wpa_supplicant";

  src = fetchurl {
    url = "https://w1.fi/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-IN965RVLODA1X4q0JpEjqHr/3qWf50/pKSqR0Nfhey8=";
  };

  patches = [
    # Fix a bug when using two config files
    ./Use-unique-IDs-for-networks-and-credentials.patch
  ] ++ lib.optionals readOnlyModeSSIDs [
    # Allow read-only networks
    ./0001-Implement-read-only-mode-for-ssids.patch
  ];

  # TODO: Patch epoll so that the dbus actually responds
  # TODO: Figure out how to get privsep working, currently getting SIGBUS
  extraConfig = ''
    #CONFIG_ELOOP_EPOLL=y
    #CONFIG_PRIVSEP=y
    #CONFIG_TLSV12=y see #8332
    CONFIG_AP=y
    CONFIG_BGSCAN_LEARN=y
    CONFIG_BGSCAN_SIMPLE=y
    CONFIG_DEBUG_SYSLOG=y
    CONFIG_EAP_EKE=y
    CONFIG_EAP_FAST=y
    CONFIG_EAP_GPSK=y
    CONFIG_EAP_GPSK_SHA256=y
    CONFIG_EAP_IKEV2=y
    CONFIG_EAP_PAX=y
    CONFIG_EAP_PWD=y
    CONFIG_EAP_SAKE=y
    CONFIG_ELOOP=eloop
    CONFIG_EXT_PASSWORD_FILE=y
    CONFIG_HS20=y
    CONFIG_HT_OVERRIDES=y
    CONFIG_IEEE80211AC=y
    CONFIG_IEEE80211N=y
    CONFIG_IEEE80211R=y
    CONFIG_IEEE80211W=y
    CONFIG_INTERNETWORKING=y
    CONFIG_L2_PACKET=linux
    CONFIG_LIBNL32=y
    CONFIG_OWE=y
    CONFIG_P2P=y
    CONFIG_TDLS=y
    CONFIG_TLS=openssl
    CONFIG_TLSV11=y
    CONFIG_VHT_OVERRIDES=y
    CONFIG_WNM=y
    CONFIG_WPS=y
    CONFIG_WPS_ER=y
    CONFIG_WPS_NFS=y
  '' + lib.optionalString withPcsclite ''
    CONFIG_EAP_SIM=y
    CONFIG_EAP_AKA=y
    CONFIG_EAP_AKA_PRIME=y
    CONFIG_PCSC=y
  '' + lib.optionalString dbusSupport ''
    CONFIG_CTRL_IFACE_DBUS=y
    CONFIG_CTRL_IFACE_DBUS_NEW=y
    CONFIG_CTRL_IFACE_DBUS_INTRO=y
  '' + (if withReadline then ''
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
      ${lib.optionalString withPcsclite "-I${lib.getDev pcsclite}/include/PCSC/"}"
  '';

  buildInputs = [ openssl libnl ]
    ++ lib.optional dbusSupport dbus
    ++ lib.optional withReadline readline
    ++ lib.optional withPcsclite pcsclite;

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

  passthru.tests = {
    inherit (nixosTests) wpa_supplicant;
    inherit wpa_supplicant_gui; # inherits the src+version updates
  };

  meta = with lib; {
    homepage = "https://w1.fi/wpa_supplicant/";
    description = "A tool for connecting to WPA and WPA2-protected wireless networks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marcweber ma27 ];
    platforms = platforms.linux;
  };
}
