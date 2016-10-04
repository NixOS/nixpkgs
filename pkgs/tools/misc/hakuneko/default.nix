{ stdenv, fetchurl, wxGTK30, openssl, curl }:

stdenv.mkDerivation rec {
  name = "hakuneko-${version}";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/hakuneko/hakuneko_${version}_src.tar.gz";
    sha256 = "d7e066e3157445f273ccf14172c05077759da036ffe700a28a409fde862b69a7";
  };

  preConfigure = ''
    substituteInPlace ./configure \
       --replace /bin/bash $shell
    '';

  buildInputs = [ wxGTK30 openssl curl ];

  meta = {
    description = "Manga downloader";
    homepage = http://sourceforge.net/projects/hakuneko/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
