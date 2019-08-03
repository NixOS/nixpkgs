{ stdenv, fetchurl, autoreconfHook, pkgconfig, openssl, botan2, log4cplus
, boost, python3, postgresql, mysql, gmp, bzip2 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "kea";
  version = "1.5.0";

  src = fetchurl {
    url = "https://ftp.isc.org/isc/${pname}/${version}/${name}.tar.gz";
    sha256 = "1v5a3prgrplw6dp9124f9gpy0kz0jrjwhnvzrw3zcynad2mlzkpd";
  };

  patches = [ ./dont-create-var.patch ];

  postPatch = ''
    substituteInPlace ./src/bin/keactrl/Makefile.am --replace '@sysconfdir@' "$out/etc"
    substituteInPlace ./src/bin/keactrl/Makefile.am --replace '@(sysconfdir)@' "$out/etc"
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--with-pgsql=${postgresql}/bin/pg_config"
    "--with-mysql=${mysql.connector-c}/bin/mysql_config"
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    openssl log4cplus boost python3 mysql.connector-c
    botan2 gmp bzip2
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://kea.isc.org/;
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
