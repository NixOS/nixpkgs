{ stdenv, fetchurl, libxml2, openssl, readline, gawk }:

stdenv.mkDerivation rec {
  name = "virtuoso-opensource-6.1.1";

  src = fetchurl {
    url = "mirror://sf/virtuoso/${name}.tar.gz";
    sha256 = "1sd70j9i26ml16lig9r9lmrdf5q0kybq71r6vzzzc5v5jxjz0l7w";
  };

  buildInputs = [ libxml2 openssl readline gawk ];

  CPP="${stdenv.gcc}/bin/gcc -E";

  configureFlags="
    --enable-shared --disable-all-vads --with-readline=${readline}
    --disable-hslookup --disable-wbxml2 --without-iodbc
    --enable-openssl=${openssl}
    ";

  postInstall=''
    echo Move documentation
    mkdir $out/share/doc
    mv $out/share/virtuoso/doc $out/share/doc/${name}
    find $out -name "*.a" -delete -o -name "*.jar" -delete -o -type d -empty -delete
    '';
  
  meta = with stdenv.lib; {
    homepage = http://virtuoso.openlinksw.com/dataspace/dav/wiki/Main/;
    platforms = platforms.all;
    maintainers = [ maintainers.urkud ];
  };
}
