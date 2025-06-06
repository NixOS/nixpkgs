{ stdenv
, lib
, fetchurl

# build time
, autoreconfHook
, pkg-config
, python3Packages

# runtime
, withMysql ? stdenv.buildPlatform.system == stdenv.hostPlatform.system
, withPostgres ? stdenv.buildPlatform.system == stdenv.hostPlatform.system
, boost
, libmysqlclient
, log4cplus
, openssl
, postgresql
, python3

# tests
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "kea";
  version = "2.6.0"; # only even minor versions are stable

  src = fetchurl {
    url = "https://ftp.isc.org/isc/${pname}/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-IHzq4z6zuB7E5qxWBSSahbk3eTM7YqrfOeSJ8R283I0=";
  };

  patches = [
    ./dont-create-var.patch
  ];

  postPatch = ''
    substituteInPlace ./src/bin/keactrl/Makefile.am --replace '@sysconfdir@' "$out/etc"
    # darwin special-casing just causes trouble
    substituteInPlace ./m4macros/ax_crypto.m4 --replace 'apple-darwin' 'nope'
  '';

  outputs = [
    "out"
    "doc"
    "man"
  ];

  configureFlags = [
    "--enable-perfdhcp"
    "--enable-shell"
    "--localstatedir=/var"
    "--with-openssl=${lib.getDev openssl}"
  ]
  ++ lib.optional withPostgres "--with-pgsql=${postgresql}/bin/pg_config"
  ++ lib.optional withMysql "--with-mysql=${lib.getDev libmysqlclient}/bin/mysql_config";

  postConfigure = ''
    # Mangle embedded paths to dev-only inputs.
    sed -e "s|$NIX_STORE/[a-z0-9]\{32\}-|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g" -i config.report
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ] ++ (with python3Packages; [
    sphinxHook
    sphinx-rtd-theme
  ]);

  sphinxBuilders = [
    "html"
    "man"
  ];
  sphinxRoot = "doc/sphinx";

  buildInputs = [
    boost
    libmysqlclient
    log4cplus
    openssl
    python3
  ];

  enableParallelBuilding = true;

  passthru.tests = {
    kea = nixosTests.kea;
    prefix-delegation = nixosTests.systemd-networkd-ipv6-prefix-delegation;
    networking-scripted = lib.recurseIntoAttrs { inherit (nixosTests.networking.scripted) dhcpDefault dhcpSimple dhcpOneIf; };
    networking-networkd = lib.recurseIntoAttrs { inherit (nixosTests.networking.networkd) dhcpDefault dhcpSimple dhcpOneIf; };
  };

  meta = with lib; {
    changelog = "https://downloads.isc.org/isc/kea/${version}/Kea-${version}-ReleaseNotes.txt";
    homepage = "https://kea.isc.org/";
    description = "High-performance, extensible DHCP server by ISC";
    longDescription = ''
      Kea is a new open source DHCPv4/DHCPv6 server being developed by
      Internet Systems Consortium. The objective of this project is to
      provide a very high-performance, extensible DHCP server engine for
      use by enterprises and service providers, either as is or with
      extensions and modifications.
    '';
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz hexa ];
  };
}
