{ stdenv
, lib
, fetchurl
, autoreconfHook
, pkg-config
, boost
, botan2
, libmysqlclient
, log4cplus
, postgresql
, python3
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "kea";
  version = "2.0.2"; # only even minor versions are stable

  src = fetchurl {
    url = "https://ftp.isc.org/isc/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-jSghO9yOK7hwo4OzCsHlPVTh66Q9L4blFRsItmqmzzI=";
  };

  patches = [ ./dont-create-var.patch ];

  postPatch = ''
    substituteInPlace ./src/bin/keactrl/Makefile.am --replace '@sysconfdir@' "$out/etc"
  '';

  configureFlags = [
    "--enable-perfdhcp"
    "--enable-shell"
    "--localstatedir=/var"
    "--with-mysql=${lib.getDev libmysqlclient}/bin/mysql_config"
    "--with-pgsql=${postgresql}/bin/pg_config"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    boost
    botan2
    libmysqlclient
    log4cplus
    python3
  ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit (nixosTests) kea;
  };

  meta = with lib; {
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
