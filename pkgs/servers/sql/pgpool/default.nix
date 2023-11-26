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
  version = "4.4.4";

  src = fetchurl {
    url = "https://www.pgpool.net/mediawiki/download.php?f=pgpool-II-${version}.tar.gz";
    name = "pgpool-II-${version}.tar.gz";
    sha256 = "sha256-EL7Wb4GXx03LAKDnP2GAZtXV4K3IeIZcL8+hyUXmj08=";
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

  patches = lib.optionals (stdenv.isDarwin) [
    # Build checks for strlcpy being available in the system, but doesn't
    # actually exclude its own copy from being built
    ./darwin-strlcpy.patch
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.pgpool.net/mediawiki/index.php/Main_Page";
    description = "A middleware that works between PostgreSQL servers and PostgreSQL clients";
    changelog = "https://www.pgpool.net/docs/latest/en/html/release-${builtins.replaceStrings ["."] ["-"] version}.html";
    license = licenses.free;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
