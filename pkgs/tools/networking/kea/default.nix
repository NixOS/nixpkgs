{ stdenv, fetchurl, autoreconfHook, pkgconfig, openssl, botan2, log4cplus
, boost, python3, postgresql, libmysqlclient, gmp, bzip2 }:

let inherit (stdenv) lib; in

stdenv.mkDerivation rec {
  pname = "kea";
  version = "1.5.0-P1";

  src = fetchurl {
    url = "https://ftp.isc.org/isc/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "0bqxzp3f7cmraa5davj2az1hx1gbbchqzlz3ai26c802agzafyhz";
  };

  patches = [ ./dont-create-var.patch ];

  postPatch = ''
    substituteInPlace ./src/bin/keactrl/Makefile.am --replace '@sysconfdir@' "$out/etc"
    substituteInPlace ./src/bin/keactrl/Makefile.am --replace '@(sysconfdir)@' "$out/etc"
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--with-pgsql=${postgresql}/bin/pg_config"
    "--with-mysql=${lib.getDev libmysqlclient}/bin/mysql_config"
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    openssl log4cplus boost python3 libmysqlclient
    botan2 gmp bzip2
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://kea.isc.org/";
    description = "High-performance, extensible DHCP server by ISC";
    longDescription = ''
      KEA is a new open source DHCPv4/DHCPv6 server being developed by
      Internet Systems Consortium. The objective of this project is to
      provide a very high-performance, extensible DHCP server engine for
      use by enterprises and service providers, either as is or with
      extensions and modifications.
    '';
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
