{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  pam,
  libkrb5,
  cyrus_sasl,
  miniupnpc,
  libxcrypt,
}:

let
  remove_getaddrinfo_checks =
    stdenv.hostPlatform.isMips64 || !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
in
stdenv.mkDerivation rec {
  pname = "dante";
  version = "1.4.3";

  src = fetchurl {
    url = "https://www.inet.no/dante/files/${pname}-${version}.tar.gz";
    sha256 = "0pbahkj43rx7rmv2x40mf5p3g3x9d6i2sz7pzglarf54w5ghd2j1";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    pam
    libkrb5
    cyrus_sasl
    miniupnpc
    libxcrypt
  ];

  configureFlags =
    if !stdenv.isDarwin then
      [ "--with-libc=libc.so.6" ]
    else
      [ "--with-libc=libc${stdenv.hostPlatform.extensions.sharedLibrary}" ];

  dontAddDisableDepTrack = stdenv.isDarwin;

  patches =
    [
      # Fixes several issues with `osint.m4` that causes incorrect check failures when using newer
      # versions of clang: missing `stdint.h` for `uint8_t` and unused `sa_len_ptr`.
      ./clang-osint-m4.patch
    ]
    ++ lib.optionals remove_getaddrinfo_checks [
      (fetchpatch {
        name = "0002-osdep-m4-Remove-getaddrinfo-too-low-checks.patch";
        url = "https://raw.githubusercontent.com/buildroot/buildroot/master/package/dante/0002-osdep-m4-Remove-getaddrinfo-too-low-checks.patch";
        sha256 = "sha256-e+qF8lB5tkiA7RlJ+tX5O6KxQrQp33RSPdP1TxU961Y=";
      })
    ];

  postPatch = ''
    substituteInPlace include/redefgen.sh --replace 'PATH=/bin:/usr/bin:/sbin:/usr/sbin' ""
  '';

  meta = with lib; {
    description = "A circuit-level SOCKS client/server that can be used to provide convenient and secure network connectivity";
    homepage = "https://www.inet.no/dante/";
    maintainers = [ maintainers.arobyn ];
    license = licenses.bsdOriginal;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
