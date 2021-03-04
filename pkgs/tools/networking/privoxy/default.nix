{ lib, stdenv, fetchurl, autoreconfHook, zlib, pcre, w3m, man }:

stdenv.mkDerivation rec {

  pname = "privoxy";
  version = "3.0.32";

  src = fetchurl {
    url = "mirror://sourceforge/ijbswa/Sources/${version}%20%28stable%29/${pname}-${version}-stable-src.tar.gz";
    sha256 = "sha256-xh3kAIxiRF7Bjx8nBAfL8jcuq6k76szcnjI4uy3v7tc=";
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
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.phreedom ];
  };

}
