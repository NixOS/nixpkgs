{ stdenv, fetchurl, pkgconfig, xapian, perl, pcre, zlib }:

stdenv.mkDerivation rec {
  name = "xapian-omega-${version}";
  version = "1.2.21";

  src = fetchurl {
    url = "http://oligarchy.co.uk/xapian/${version}/xapian-omega-${version}.tar.xz";
    sha256 = "0zjjr4ypanwrjkcpgi37d72v2jjcfwnw8lgddv0i7z2jf1fklbc6";
  };

  buildInputs = [ pkgconfig xapian perl pcre zlib ];

  meta = with stdenv.lib; {
    description = "Indexer and CGI search front-end built on Xapian library";
    homepage = http://xapian.org/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
