{ lib
, stdenv
, fetchurl
, fetchpatch
, nixosTests
, pkg-config
, systemd
, gmp
, unbound
, bison
, flex
, pam
, libevent
, libcap_ng
, libxcrypt
, curl
, nspr
, bash
, runtimeShell
, iproute2
, iptables
, procps
, coreutils
, gnused
, gawk
, nss
, which
, python3
, libselinux
, ldns
, xmlto
, docbook_xml_dtd_412
, docbook_xsl
, findXMLCatalogs
, dns-root-data
}:

let
  # Tools needed by ipsec scripts
  binPath = lib.makeBinPath [
    iproute2 iptables procps
    coreutils gnused gawk
    nss.tools which
  ];
in

stdenv.mkDerivation rec {
  pname = "libreswan";
  version = "4.9";

  src = fetchurl {
    url = "https://download.libreswan.org/${pname}-${version}.tar.gz";
    sha256 = "sha256-9kLctjXpCVZMqP2Z6kSrQ/YHI7TXbBWO2BKXjEWzmLk=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-23009.patch";
      url = "https://libreswan.org/security/CVE-2023-23009/CVE-2023-23009-libreswan-4.4-4.9.patch";
      sha256 = "sha256-HJyp7y7ROfMVg5/e/JyOHlXTyVkw0dAVmNHwTAqlFmQ=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    bison
    flex
    pkg-config
    xmlto
    docbook_xml_dtd_412
    docbook_xsl
    findXMLCatalogs
  ];

  buildInputs = [
    systemd coreutils
    gnused gawk gmp unbound pam libevent
    libcap_ng libxcrypt curl nspr nss ldns
    # needed to patch shebangs
    python3 bash
  ] ++ lib.optional stdenv.isLinux libselinux;

  prePatch = ''
    # Correct iproute2 and iptables path
    sed -e 's|/sbin/ip|${iproute2}/bin/ip|g' \
        -e 's|/sbin/\(ip6\?tables\)|${iptables}/bin/\1|' \
        -e 's|/bin/bash|${runtimeShell}|g' \
        -i initsystems/systemd/ipsec.service.in \
           programs/barf/barf.in \
           programs/verify.linux/verify.in
    sed -e 's|\([[:blank:]]\)\(ip6\?tables\(-save\)\? -\)|\1${iptables}/bin/\2|' \
        -i programs/verify.linux/verify.in

    # Prevent the makefile from trying to
    # reload the systemd daemon or create tmpfiles
    sed -e 's|systemctl|true|g' \
        -e 's|systemd-tmpfiles|true|g' \
        -i initsystems/systemd/Makefile

    # Fix the ipsec program from crushing the PATH
    sed -e 's|\(PATH=".*"\):.*$|\1:$PATH|' -i programs/ipsec/ipsec.in

    # Fix python script to use the correct python
    sed -e 's/^\(\W*\)installstartcheck()/\1sscmd = "ss"\n\0/' \
        -i programs/verify.linux/verify.in

    # Replace wget with curl to save a dependency
    curlArgs='-s --remote-name-all --output-dir'
    sed -e "s|wget -q -P|${curl}/bin/curl $curlArgs|g" \
        -i programs/letsencrypt/letsencrypt.in

    # Patch the Makefile:
    # 1. correct the pam.d directory install path
    # 2. do not create the /var/lib/ directory
    sed -e 's|$(DESTDIR)/etc/pam.d|$(out)/etc/pam.d|' \
        -e '/test ! -d $(NSSDIR)/,+3d' \
        -i configs/Makefile
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "INITSYSTEM=systemd"
    "UNITDIR=$(out)/etc/systemd/system/"
    "TMPFILESDIR=$(out)/lib/tmpfiles.d/"
    "LINUX_VARIANT=nixos"
    "DEFAULT_DNSSEC_ROOTKEY_FILE=${dns-root-data}/root.key"
  ];

  # Hack to make install work
  installFlags = [
    "FINALVARDIR=\${out}/var"
    "FINALSYSCONFDIR=\${out}/etc"
  ];

  postInstall = ''
    # Install examples directory (needed for letsencrypt)
    cp -r docs/examples $out/share/doc/libreswan/examples
  '';

  postFixup = ''
    # Add a PATH to the main "ipsec" script
    sed -e '0,/^$/{s||export PATH=${binPath}:$PATH|}' \
        -i $out/bin/ipsec
  '';

  passthru.tests.libreswan = nixosTests.libreswan;

  meta = with lib; {
    homepage = "https://libreswan.org";
    description = "A free software implementation of the VPN protocol based on IPSec and the Internet Key Exchange";
    platforms = platforms.linux ++ platforms.freebsd;
    license = with licenses; [ gpl2Plus mpl20 ] ;
    maintainers = with maintainers; [ afranchuk rnhmjoj ];
  };
}
