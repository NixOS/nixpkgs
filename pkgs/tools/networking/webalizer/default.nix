{ lib, stdenv, fetchurl, zlib, libpng, gd, geoip, db }:

stdenv.mkDerivation rec {
  pname = "webalizer";
  version = "2.23.08";

  src = fetchurl {
    url = "https://ftp.debian.org/debian/pool/main/w/webalizer/webalizer_${version}.orig.tar.gz";
    sha256 = "sha256-7a3bWqQcxKCBoVAOP6lmFdS0G8Eghrzt+ZOAGM557Y0=";
  };

  # Workaround build failure on -fno-common toolchains:
  #   ld: dns_resolv.o:(.bss+0x20): multiple definition of `system_info'; webalizer.o:(.bss+0x76e0): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  installFlags = [ "MANDIR=\${out}/share/man/man1" ];

  preConfigure =
    ''
      substituteInPlace ./configure \
        --replace "--static" ""
    '';

  buildInputs = [ zlib libpng gd geoip db ];

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
