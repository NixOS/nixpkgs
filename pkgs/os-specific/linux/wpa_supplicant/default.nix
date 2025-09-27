{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  openssl,
  pkg-config,
  libnl,
  nixosTests,
  wpa_supplicant_gui,
  dbusSupport ? !stdenv.hostPlatform.isStatic,
  dbus,
  withReadline ? true,
  readline,
  withPcsclite ? !stdenv.hostPlatform.isStatic,
  pcsclite,
}:

stdenv.mkDerivation rec {
  version = "2.11";

  pname = "wpa_supplicant";

  src = fetchurl {
    url = "https://w1.fi/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-kS6gb3TjCo42+7aAZNbN/yGNjVkdsPxddd7myBrH/Ao=";
  };

  patches = [
    (fetchpatch {
      name = "revert-change-breaking-auth-broadcom.patch";
      url = "https://w1.fi/cgit/hostap/patch/?id=41638606054a09867fe3f9a2b5523aa4678cbfa5";
      hash = "sha256-X6mBbj7BkW66aYeSCiI3JKBJv10etLQxaTRfRgwsFmM=";
      revert = true;
    })
    ./unsurprising-ext-password.patch
    ./multiple-configs.patch
    (fetchpatch {
      name = "suppress-ctrl-event-signal-change.patch";
      url = "https://w1.fi/cgit/hostap/patch/?id=c330b5820eefa8e703dbce7278c2a62d9c69166a";
      hash = "sha256-5ti5OzgnZUFznjU8YH8Cfktrj4YBzsbbrEbNvec+ppQ=";
    })
    (fetchpatch {
      name = "ensure-full-key-match";
      url = "https://git.w1.fi/cgit/hostap/patch/?id=1ce37105da371c8b9cf3f349f78f5aac77d40836";
      hash = "sha256-leCk0oexNBZyVK5Q5gR4ZcgWxa0/xt/aU+DssTa0UwE=";
    })
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
    CONFIG_IEEE80211AX=y
    CONFIG_IEEE80211BE=y
    CONFIG_IEEE80211N=y
    CONFIG_IEEE80211R=y
    CONFIG_IEEE80211W=y
    CONFIG_INTERNETWORKING=y
    CONFIG_L2_PACKET=linux
    CONFIG_LIBNL32=y
    CONFIG_MESH=y
    CONFIG_OWE=y
    CONFIG_P2P=y
    CONFIG_SAE_PK=y
    CONFIG_TDLS=y
    CONFIG_TLS=openssl
    CONFIG_TLSV11=y
    CONFIG_VHT_OVERRIDES=y
    CONFIG_WNM=y
    CONFIG_WPS=y
    CONFIG_WPS_ER=y
    CONFIG_WPS_NFS=y
    CONFIG_SUITEB=y
    CONFIG_SUITEB192=y
  ''
  + lib.optionalString withPcsclite ''
    CONFIG_EAP_SIM=y
    CONFIG_EAP_AKA=y
    CONFIG_EAP_AKA_PRIME=y
    CONFIG_PCSC=y
  ''
  + lib.optionalString dbusSupport ''
    CONFIG_CTRL_IFACE_DBUS=y
    CONFIG_CTRL_IFACE_DBUS_NEW=y
    CONFIG_CTRL_IFACE_DBUS_INTRO=y
  ''
  # Upstream uses conditionals based on ifdef, so opposite of =y is
  # not =n, as one may expect, but undefine.
  #
  # This config is sourced into makefile.
  + lib.optionalString (!dbusSupport) ''
    undefine CONFIG_CTRL_IFACE_DBUS
    undefine CONFIG_CTRL_IFACE_DBUS_NEW
    undefine CONFIG_CTRL_IFACE_DBUS_INTRO
  ''
  + (
    if withReadline then
      ''
        CONFIG_READLINE=y
      ''
    else
      ''
        CONFIG_WPA_CLI_EDIT=y
      ''
  );

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

  buildInputs = [
    openssl
    libnl
  ]
  ++ lib.optional dbusSupport dbus
  ++ lib.optional withReadline readline
  ++ lib.optional withPcsclite pcsclite;

  nativeBuildInputs = [ pkg-config ];

  postInstall = ''
    mkdir -p $out/share/man/man5 $out/share/man/man8
    cp -v "doc/docbook/"*.5 $out/share/man/man5/
    cp -v "doc/docbook/"*.8 $out/share/man/man8/
  ''
  + lib.optionalString dbusSupport ''
    mkdir -p $out/share/dbus-1/system.d $out/share/dbus-1/system-services $out/etc/systemd/system
    cp -v "dbus/"*service $out/share/dbus-1/system-services
    cp -v dbus/dbus-wpa_supplicant.conf $out/share/dbus-1/system.d
    cp -v "systemd/"*.service $out/etc/systemd/system
  ''
  + ''
    rm $out/share/man/man8/wpa_priv.8
    install -Dm444 wpa_supplicant.conf $out/share/doc/wpa_supplicant/wpa_supplicant.conf.example
  '';

  passthru.tests = {
    inherit (nixosTests) wpa_supplicant;
    inherit wpa_supplicant_gui; # inherits the src+version updates
  };

  meta = with lib; {
    homepage = "https://w1.fi/wpa_supplicant/";
    description = "Tool for connecting to WPA and WPA2-protected wireless networks";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      marcweber
      ma27
    ];
    platforms = platforms.linux;
  };
}
