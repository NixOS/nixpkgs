{ lib, stdenv, fetchurl, zlib, libpng, gd, geoip, db }:

stdenv.mkDerivation rec {
  pname = "webalizer";
  version = "2.23-05";

  src = fetchurl {
    url = "ftp://ftp.mrunix.net/pub/webalizer/webalizer-${version}-src.tar.bz2";
    sha256 = "0nl88y57a7gawfragj3viiigfkh5sgivfb4n0k89wzcjw278pj5g";
  };

  # Workaround build failure on -fno-common toolchains:
  #   ld: dns_resolv.o:(.bss+0x20): multiple definition of `system_info'; webalizer.o:(.bss+0x76e0): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  preConfigure =
    ''
      substituteInPlace ./configure \
        --replace "--static" ""
    '';

  buildInputs = [zlib libpng gd geoip db];

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
