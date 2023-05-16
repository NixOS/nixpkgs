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
<<<<<<< HEAD
  version = "4.4.3";
=======
  version = "4.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchurl {
    url = "https://www.pgpool.net/mediawiki/download.php?f=pgpool-II-${version}.tar.gz";
    name = "pgpool-II-${version}.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-RnRaqY9FTgl87LTaz1NvicN+0+xB8y8KhGk0Ip0OtzM=";
=======
    sha256 = "sha256-Pmx4jnDwZyx7OMiKbKdvMfN4axJWiZgMwGOrdSylgjQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  patches = lib.optionals (stdenv.isDarwin) [
    # Build checks for strlcpy being available in the system, but doesn't
    # actually exclude its own copy from being built
    ./darwin-strlcpy.patch
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://pgpool.net/mediawiki/index.php";
    description = "A middleware that works between postgresql servers and postgresql clients";
    license = licenses.free;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
