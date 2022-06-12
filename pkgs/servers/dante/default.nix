{ lib, stdenv, fetchurl, fetchpatch, pam, libkrb5, cyrus_sasl, miniupnpc, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "dante";
  version = "1.4.3";

  src = fetchurl {
    url = "https://www.inet.no/dante/files/${pname}-${version}.tar.gz";
    sha256 = "0pbahkj43rx7rmv2x40mf5p3g3x9d6i2sz7pzglarf54w5ghd2j1";
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isMips64 autoreconfHook;
  buildInputs = [ pam libkrb5 cyrus_sasl miniupnpc ];

  configureFlags = if !stdenv.isDarwin
    then [ "--with-libc=libc.so.6" ]
    else [ "--with-libc=libc${stdenv.targetPlatform.extensions.sharedLibrary}" ];

  dontAddDisableDepTrack = stdenv.isDarwin;

  patches = lib.optional stdenv.hostPlatform.isMips64 [
    (fetchpatch {
      name = "0002-osdep-m4-Remove-getaddrinfo-too-low-checks.patch";
      url = "https://raw.githubusercontent.com/buildroot/buildroot/master/package/dante/0002-osdep-m4-Remove-getaddrinfo-too-low-checks.patch";
      sha256 = "sha256-e+qF8lB5tkiA7RlJ+tX5O6KxQrQp33RSPdP1TxU961Y=";
    }) ];

  postPatch = ''
    substituteInPlace include/redefgen.sh --replace 'PATH=/bin:/usr/bin:/sbin:/usr/sbin' ""
  '';

  meta = with lib; {
    description = "A circuit-level SOCKS client/server that can be used to provide convenient and secure network connectivity";
    homepage    = "https://www.inet.no/dante/";
    maintainers = [ maintainers.arobyn ];
    license     = licenses.bsdOriginal;
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
