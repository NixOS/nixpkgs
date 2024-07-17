{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
  pkg-config,
  systemd,
  gmp,
  unbound,
  bison,
  flex,
  pam,
  libevent,
  libcap_ng,
  libxcrypt,
  curl,
  nspr,
  bash,
  runtimeShell,
  iproute2,
  iptables,
  procps,
  coreutils,
  gnused,
  gawk,
  nss,
  which,
  python3,
  libselinux,
  ldns,
  xmlto,
  docbook_xml_dtd_45,
  docbook_xsl,
  findXMLCatalogs,
  dns-root-data,
}:

let
  # Tools needed by ipsec scripts
  binPath = lib.makeBinPath [
    iproute2
    iptables
    procps
    coreutils
    gnused
    gawk
    nss.tools
    which
  ];
in

stdenv.mkDerivation rec {
  pname = "libreswan";
  version = "5.0";

  src = fetchurl {
    url = "https://download.libreswan.org/${pname}-${version}.tar.gz";
    hash = "sha256-ELwK3JC56YGjDf77p9r/IAhB7LmRD51nHxN//BQUKGo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bison
    flex
    pkg-config
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
    findXMLCatalogs
  ];

  buildInputs = [
    systemd
    coreutils
    gnused
    gawk
    gmp
    unbound
    pam
    libevent
    libcap_ng
    libxcrypt
    curl
    nspr
    nss
    ldns
    # needed to patch shebangs
    python3
    bash
  ] ++ lib.optional stdenv.isLinux libselinux;

  prePatch = ''
    # Replace wget with curl to save a dependency
    substituteInPlace programs/letsencrypt/letsencrypt.in \
      --replace-fail 'wget -q -P' '${curl}/bin/curl -s --remote-name-all --output-dir'
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "INITSYSTEM=systemd"
    "SYSTEMUNITDIR=$(out)/etc/systemd/system/"
    "TMPFILESDIR=$(out)/lib/tmpfiles.d/"
    "LINUX_VARIANT=nixos"
    "DEFAULT_DNSSEC_ROOTKEY_FILE=${dns-root-data}/root.key"
  ];

  # Hack to make install work
  installFlags = [
    "VARDIR=\${out}/var"
    "SYSCONFDIR=\${out}/etc"
  ];

  postInstall = ''
    # Install letsencrypt config files
    install -m644 -Dt "$out/share/doc/libreswan/letsencrypt" docs/examples/*
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
    license = with licenses; [
      gpl2Plus
      mpl20
    ];
    maintainers = with maintainers; [
      afranchuk
      rnhmjoj
    ];
    mainProgram = "ipsec";
  };
}
