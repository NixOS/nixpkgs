{ stdenv, fetchpatch, fetchurl, openssl, pkgconfig, libnl
, dbus, readline ? null, pcsclite ? null
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "2.7";

  name = "wpa_supplicant-${version}";

  src = fetchurl {
    url = "https://w1.fi/releases/${name}.tar.gz";
    sha256 = "0x1hqyahq44jyla8jl6791nnwrgicrhidadikrnqxsm2nw36pskn";
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
    # SAE and EAP_PWD vulnerabilities
    #
    # CVE-2019-9494 https://w1.fi/security/2019-1
    # CVE-2019-9495 https://w1.fi/security/2019-2
    # CVE-2019-9496 https://w1.fi/security/2019-3
    # CVE-2019-9497 https://w1.fi/security/2019-4
    # CVE-2019-9498 https://w1.fi/security/2019-4
    # CVE-2019-9499 https://w1.fi/security/2019-4
    (fetchurl {
      url = "https://w1.fi/security/2019-1/0001-OpenSSL-Use-constant-time-operations-for-private-big.patch";
      sha256 = "0rqc7snk11cinvrik23ajv0dqdlsyv6qlgpqrf55gaf5y5ard5w6";
    })
    (fetchurl {
      url = "https://w1.fi/security/2019-1/0002-Add-helper-functions-for-constant-time-operations.patch";
      sha256 = "0w8fx695nw4iq3v39f6b5h0ahixd66w5mjd8ps84qd6cbqbxlqsn";
    })
    (fetchurl {
      url = "https://w1.fi/security/2019-1/0003-OpenSSL-Use-constant-time-selection-for-crypto_bignu.patch";
      sha256 = "0r3za7x96k7br8np4xg8ndcqm5b41bmrq8s0ax4x8lbkb2gvr9p5";
    })
    (fetchurl {
      url = "https://w1.fi/security/2019-2/0004-EAP-pwd-Use-constant-time-and-memory-access-for-find.patch";
      sha256 = "0aircjl85s68njkgr2b9hq7hvzla0hykqrd3i7zpbwdsxcmp4nxa";
    })
    (fetchurl {
      url = "https://w1.fi/security/2019-1/0005-SAE-Minimize-timing-differences-in-PWE-derivation.patch";
      sha256 = "08xlkpwysssm8hy3n65nk5g70gd07c5q4657lw1q7y0qn6pfxnds";
    })
    (fetchurl {
      url = "https://w1.fi/security/2019-1/0006-SAE-Avoid-branches-in-is_quadratic_residue_blind.patch";
      sha256 = "0h2vw1k4lrwzkxgwz1c5frz6vjx63fv6m1b8v1xggxjjyr8f8yxf";
    })
    (fetchurl {
      url = "https://w1.fi/security/2019-1/0007-SAE-Mask-timing-of-MODP-groups-22-23-24.patch";
      sha256 = "02abzhy5fl1cwyl6b10sz1msfb3f2fdpdyr03l0aqn6ahz3k3dw6";
    })
    (fetchurl {
      url = "https://w1.fi/security/2019-1/0008-SAE-Use-const_time-selection-for-PWE-in-FFC.patch";
      sha256 = "1zpds6q9rpgbr7mba7xk39wdpcdikxmqhiz2v8c4i8qpa800awzz";
    })
    (fetchurl {
      url = "https://w1.fi/security/2019-1/0009-SAE-Use-constant-time-operations-in-sae_test_pwd_see.patch";
      sha256 = "196al51k4hg9y67rr1sq96d2ig07wkdka8gqa0rpdzk01v65fw3h";
    })
    (fetchurl {
      url = "https://w1.fi/security/2019-3/0010-SAE-Fix-confirm-message-validation-in-error-cases.patch";
      sha256 = "1ahbwz8lybp7kchrqn06b54dch2flziyyas1nny78dpymd7sxn42";
    })
    (fetchurl {
      url = "https://w1.fi/security/2019-4/0011-EAP-pwd-server-Verify-received-scalar-and-element.patch";
      sha256 = "0fqf3i88w6ca99k3fkv5rnrsbsyj4ixgdniwwrxrh0abmn96v3gz";
    })
    (fetchurl {
      url = "https://w1.fi/security/2019-4/0012-EAP-pwd-server-Detect-reflection-attacks.patch";
      sha256 = "1k32804nang2grlmizbhxac3j9s2qnaq29pr6p0a1s8hm3jz9sym";
    })
    (fetchurl {
      url = "https://w1.fi/security/2019-4/0013-EAP-pwd-client-Verify-received-scalar-and-element.patch";
      sha256 = "1y1fzmpigd0kdnzdmwb1czkwiz592yfsa9lsnsh28fzhk1j6amki";
    })
    (fetchurl {
      url = "https://w1.fi/security/2019-4/0014-EAP-pwd-Check-element-x-y-coordinates-explicitly.patch";
      sha256 = "0rhw5jh37rpbcyjy6cnj01j5sk3n091g0y8g57ddly9axia6i4k9";
    })
    (fetchpatch {
      name = "build-fix.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/net-wireless/wpa_supplicant/files/wpa_supplicant-2.7-fix-undefined-remove-ie.patch?id=e0288112138a70a8acc3ae0196772fd7ccb677ce";
      sha256 = "0ysazfcyn195mvkb1v10mgzzmpmqgv5kwqxwzfbsfhzq5bbaihld";
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
