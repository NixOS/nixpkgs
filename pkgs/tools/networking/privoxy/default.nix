{ lib, stdenv, fetchurl, autoreconfHook, zlib, pcre, w3m, man }:

stdenv.mkDerivation rec {

  pname = "privoxy";
  version = "3.0.30";

  src = fetchurl {
    url = "mirror://sourceforge/ijbswa/Sources/${version}%20%28stable%29/${pname}-${version}-stable-src.tar.gz";
    sha256 = "sha256-pP4kHF2nAQsoS/ienp4xoyHx8+scx5ZVnT+6ublBXuE=";
  };

  hardeningEnable = [ "pie" ];

  nativeBuildInputs = [ autoreconfHook w3m man ];
  buildInputs = [ zlib pcre ];

  makeFlags = [ "STRIP="];

  postInstall = ''
    rm -rf $out/var
  '';

  meta = with lib; {
    homepage = "https://www.privoxy.org/";
    description = "Non-caching web proxy with advanced filtering capabilities";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.phreedom ];
  };

}
