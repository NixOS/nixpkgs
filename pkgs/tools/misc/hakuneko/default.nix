{ stdenv, fetchurl, wxGTK, openssl, curl }:

stdenv.mkDerivation rec {
  name = "hakuneko-${version}";
  version = "1.3.12";

  src = fetchurl {
    url = "mirror://sourceforge/hakuneko/hakuneko_${version}_src.tar.gz";
    sha256 = "24e7281a7f68b24e5260ee17ecfa1c5a3ffec408c8ea6e0121ae6c161898b698";
  };

  preConfigure = ''
    substituteInPlace ./configure \
       --replace /bin/bash $shell
    '';

  buildInputs = [ wxGTK openssl curl ];

  meta = {
    description = "Manga downloader";
    homepage = http://sourceforge.net/projects/hakuneko/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
