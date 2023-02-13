{ lib
, stdenv
, fetchurl
, postgresql
, openssl
, libxcrypt
, withPam ? stdenv.isLinux
, pam
}:

stdenv.mkDerivation rec {
  pname = "pgpool-II";
  version = "4.4.2";

  src = fetchurl {
    url = "https://www.pgpool.net/mediawiki/download.php?f=pgpool-II-${version}.tar.gz";
    name = "pgpool-II-${version}.tar.gz";
    sha256 = "sha256-Pmx4jnDwZyx7OMiKbKdvMfN4axJWiZgMwGOrdSylgjQ=";
  };

  buildInputs = [
    postgresql
    openssl
    libxcrypt
  ] ++ lib.optional withPam pam;

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-openssl"
  ] ++ lib.optional withPam "--with-pam";

  installFlags = [
    "sysconfdir=\${out}/etc"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://pgpool.net/mediawiki/index.php";
    description = "A middleware that works between postgresql servers and postgresql clients";
    license = licenses.free;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
