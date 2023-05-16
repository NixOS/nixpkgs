{ lib, stdenv, fetchurl, zlib, libpng, gd, geoip, db }:

stdenv.mkDerivation rec {
  pname = "webalizer";
<<<<<<< HEAD
  version = "2.23.08";

  src = fetchurl {
    url = "https://ftp.debian.org/debian/pool/main/w/webalizer/webalizer_${version}.orig.tar.gz";
    sha256 = "sha256-7a3bWqQcxKCBoVAOP6lmFdS0G8Eghrzt+ZOAGM557Y0=";
=======
  version = "2.23-05";

  src = fetchurl {
    url = "ftp://ftp.mrunix.net/pub/webalizer/webalizer-${version}-src.tar.bz2";
    sha256 = "0nl88y57a7gawfragj3viiigfkh5sgivfb4n0k89wzcjw278pj5g";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Workaround build failure on -fno-common toolchains:
  #   ld: dns_resolv.o:(.bss+0x20): multiple definition of `system_info'; webalizer.o:(.bss+0x76e0): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

<<<<<<< HEAD
  installFlags = [ "MANDIR=\${out}/share/man/man1" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preConfigure =
    ''
      substituteInPlace ./configure \
        --replace "--static" ""
    '';

<<<<<<< HEAD
  buildInputs = [ zlib libpng gd geoip db ];
=======
  buildInputs = [zlib libpng gd geoip db];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  configureFlags = [
    "--enable-dns"
    "--enable-geoip"
    "--enable-shared"
  ];

  meta = with lib; {
    description = "Web server log file analysis program";
    homepage = "https://webalizer.net/";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
