{ lib, stdenv
, nixosTests
, fetchurl, autoreconfHook
, zlib, pcre, w3m, man
, mbedtls, brotli
}:

stdenv.mkDerivation rec {

  pname = "privoxy";
  version = "3.0.32";

  src = fetchurl {
    url = "mirror://sourceforge/ijbswa/Sources/${version}%20%28stable%29/${pname}-${version}-stable-src.tar.gz";
    sha256 = "sha256-xh3kAIxiRF7Bjx8nBAfL8jcuq6k76szcnjI4uy3v7tc=";
  };

  hardeningEnable = [ "pie" ];

  nativeBuildInputs = [ autoreconfHook w3m man ];
  buildInputs = [ zlib pcre mbedtls brotli ];

  makeFlags = [ "STRIP=" ];
  configureFlags = [
    "--with-mbedtls"
    "--with-brotli"
    "--enable-external-filters"
    "--enable-compression"
  ];

  postInstall = ''
    rm -r $out/var
  '';

  passthru.tests.privoxy = nixosTests.privoxy;

  meta = with lib; {
    homepage = "https://www.privoxy.org/";
    description = "Non-caching web proxy with advanced filtering capabilities";
    # When linked with mbedtls, the license becomes GPLv3 (or later), otherwise
    # GPLv2 (or later). See https://www.privoxy.org/user-manual/copyright.html
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.phreedom ];
  };

}
