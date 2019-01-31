{ stdenv, fetchurl, openssl, pkgconfig, libnl
, dbus, readline ? null, pcsclite ? null
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "2.6";

  name = "wpa_supplicant-${version}";

  src = fetchurl {
    url = "https://w1.fi/releases/${name}.tar.gz";
    sha256 = "0l0l5gz3d5j9bqjsbjlfcv4w4jwndllp9fmyai4x9kg6qhs6v4xl";
  };

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
      -I$(echo "${stdenv.lib.getDev libnl}"/include/libnl*/) \
      -I${stdenv.lib.getDev pcsclite}/include/PCSC/"
  '';

  buildInputs = [ openssl libnl dbus readline pcsclite ];

  nativeBuildInputs = [ pkgconfig ];

  patches = [
    ./build-fix.patch

    # KRACKAttack.com
    (fetchurl {
      url = "http://w1.fi/security/2017-1/rebased-v2.6-0001-hostapd-Avoid-key-reinstallation-in-FT-handshake.patch";
      sha256 = "02zl2x4pxay666yq18g4f3byccrzipfjbky1ydw62v15h76174aj";
    })
    (fetchurl {
      url = "http://w1.fi/security/2017-1/rebased-v2.6-0002-Prevent-reinstallation-of-an-already-in-use-group-ke.patch";
      sha256 = "1mrmqg00x1bqa43dyhxb14msk74lh3kvr4avni43c3qpfjmlfvfq";
    })
    (fetchurl {
      url = "http://w1.fi/security/2017-1/rebased-v2.6-0003-Extend-protection-of-GTK-IGTK-reinstallation-of-WNM-.patch";
      sha256 = "10byyi8wfpcc8i788ag7ndycd3xvq2iwnssyb3rwf34sfcv5wlyl";
    })
    (fetchurl {
      url = "http://w1.fi/security/2017-1/rebased-v2.6-0004-Prevent-installation-of-an-all-zero-TK.patch";
      sha256 = "02z2rsbh4sw81wsc56xjbblbi76ii0clmpnr1m1szdb1h5s58fkr";
    })
    (fetchurl {
      url = "http://w1.fi/security/2017-1/rebased-v2.6-0005-Fix-PTK-rekeying-to-generate-a-new-ANonce.patch";
      sha256 = "17pbrn5h6l5v14y6gn2yr2knqya9i0n2vyq4ck8hasb00yz8lz0l";
    })
    (fetchurl {
      url = "http://w1.fi/security/2017-1/rebased-v2.6-0006-TDLS-Reject-TPK-TK-reconfiguration.patch";
      sha256 = "19mgcqbdyzm4myi182jcn1rn26xi3jib74cpxbbrx1gaccxlsvar";
    })
    (fetchurl { # wpa-supplicant only
      url = "http://w1.fi/security/2017-1/rebased-v2.6-0007-WNM-Ignore-WNM-Sleep-Mode-Response-without-pending-r.patch";
      sha256 = "0di71j8762dkvr0c7h5mrbkqyfdy8mljvnp0dk2qhbgc9bw7m8f5";
    })
    (fetchurl {
      url = "http://w1.fi/security/2017-1/rebased-v2.6-0008-FT-Do-not-allow-multiple-Reassociation-Response-fram.patch";
      sha256 = "1ca312cixbld70rp12q7h66lnjjxzz0qag0ii2sg6cllgf2hv168";
    })

    # Unauthenticated EAPOL-Key decryption (CVE-2018-14526)
    (fetchurl {
      url = "https://w1.fi/security/2018-1/rebased-v2.6-0001-WPA-Ignore-unauthenticated-encrypted-EAPOL-Key-data.patch";
      sha256 = "0z0zxc9wrikmvciyqpdhx0l5v7qsd8c6b5ph9h5rniqllpr3q34n";
    })
  ];

  postInstall = ''
    mkdir -p $out/share/man/man5 $out/share/man/man8
    cp -v "doc/docbook/"*.5 $out/share/man/man5/
    cp -v "doc/docbook/"*.8 $out/share/man/man8/
    mkdir -p $out/etc/dbus-1/system.d $out/share/dbus-1/system-services $out/etc/systemd/system
    cp -v "dbus/"*service $out/share/dbus-1/system-services
    sed -e "s@/sbin/wpa_supplicant@$out&@" -i "$out/share/dbus-1/system-services/"*
    cp -v dbus/dbus-wpa_supplicant.conf $out/etc/dbus-1/system.d
    cp -v "systemd/"*.service $out/etc/systemd/system
    rm $out/share/man/man8/wpa_priv.8
    install -Dm444 wpa_supplicant.conf $out/share/doc/wpa_supplicant/wpa_supplicant.conf.example
  '';

  meta = with stdenv.lib; {
    homepage = http://hostap.epitest.fi/wpa_supplicant/;
    description = "A tool for connecting to WPA and WPA2-protected wireless networks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.linux;
  };
}
