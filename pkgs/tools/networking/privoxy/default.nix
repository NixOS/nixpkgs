{ stdenv, fetchurl, autoreconfHook, zlib, pcre, w3m, man }:

stdenv.mkDerivation rec{

  name = "privoxy-${version}";
  version = "3.0.26";

  src = fetchurl {
    url = "mirror://sourceforge/ijbswa/Sources/${version}%20%28stable%29/${name}-stable-src.tar.gz";
    sha256 = "1n4wpxmahl8m2y3d1azxa8lrdbpaad007k458skxrpz57ss1br2p";
  };

  hardeningEnable = [ "pie" ];

  nativeBuildInputs = [ autoreconfHook w3m man ];
  buildInputs = [ zlib pcre ];

  makeFlags = [ "STRIP="];

  postInstall = ''
    rm -rf $out/var
  '';

  meta = with stdenv.lib; {
    homepage = https://www.privoxy.org/;
    description = "Non-caching web proxy with advanced filtering capabilities";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.phreedom ];
  };

}
