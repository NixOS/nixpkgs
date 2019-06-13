{ stdenv, fetchurl, autoreconfHook, zlib, pcre, w3m, man }:

stdenv.mkDerivation rec{

  name = "privoxy-${version}";
  version = "3.0.28";

  src = fetchurl {
    url = "mirror://sourceforge/ijbswa/Sources/${version}%20%28stable%29/${name}-stable-src.tar.gz";
    sha256 = "0jl2yav1qzqnaqnnx8i6i53ayckkimcrs3l6ryvv7bda6v08rmxm";
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
