{ stdenv, fetchurl, wxGTK30, openssl, curl }:

stdenv.mkDerivation rec {
  name = "hakuneko-${version}";
  version = "1.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/hakuneko/hakuneko_${version}_src.tar.gz";
    sha256 = "76a63fa05e91b082cb5a70a8abacef005354e99978ff8b1369f7aa0af7615d52";
  };

  preConfigure = ''
    substituteInPlace ./configure \
       --replace /bin/bash $shell
    '';

  buildInputs = [ wxGTK30 openssl curl ];

  meta = {
    description = "Manga downloader";
    homepage = https://sourceforge.net/projects/hakuneko/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
