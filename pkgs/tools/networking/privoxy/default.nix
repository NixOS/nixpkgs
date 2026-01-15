{
  lib,
  stdenv,
  nixosTests,
  fetchpatch,
  fetchurl,
  autoreconfHook,
  zlib,
  pcre,
  w3m,
  man,
  openssl,
  brotli,
}:

stdenv.mkDerivation rec {

  pname = "privoxy";
  version = "4.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/ijbswa/Sources/${version}%20%28stable%29/${pname}-${version}-stable-src.tar.gz";
    sha256 = "sha256-wI4roASTBwF7+dimPdKg37lqoM3rNK4Ad3bmPrpiom8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    w3m
    man
  ];
  buildInputs = [
    zlib
    pcre
    openssl
    brotli
  ];

  makeFlags = [ "STRIP=" ];
  configureFlags = [
    "--with-openssl"
    "--with-brotli"
    "--enable-external-filters"
    "--enable-compression"
  ];

  postInstall = ''
    rm -r $out/var
  '';

  passthru.tests.privoxy = nixosTests.privoxy;

  meta = {
    homepage = "https://www.privoxy.org/";
    description = "Non-caching web proxy with advanced filtering capabilities";
    # When linked with mbedtls, the license becomes GPLv3 (or later), otherwise
    # GPLv2 (or later). See https://www.privoxy.org/user-manual/copyright.html
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "privoxy";
  };

}
