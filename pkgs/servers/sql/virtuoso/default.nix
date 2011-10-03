{ stdenv, fetchurl, libxml2, openssl, readline, gawk }:

stdenv.mkDerivation rec {
  name = "virtuoso-opensource-6.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/virtuoso/${name}.tar.gz";
    sha256 = "0rj629qjsibpllazngbhzhsh90x6nidpn292qz1xdvirwvb2h3s2";
  };

  buildInputs = [ libxml2 openssl readline gawk ];

  patchFlags = "-p0";

  patches =
    [ (fetchurl {
        url = "http://bugsfiles.kde.org/attachment.cgi?id=63510";
        name = "virtuoso-charset-fix.diff";
        sha256 = "09kxjhsy3rbys0bcxpmgga4sa6qjyy79dyl4n8b0gp1hnzjskvkz";
      })
    ];

  CPP = "${stdenv.gcc}/bin/gcc -E";

  configureFlags = "
    --enable-shared --disable-all-vads --with-readline=${readline}
    --disable-hslookup --disable-wbxml2 --without-iodbc
    --enable-openssl=${openssl}
    ";

  postInstall=''
    echo Moving documentation
    mkdir -pv $out/share/doc
    mv -v $out/share/virtuoso/doc $out/share/doc/${name}
    find $out -name "*.a" -delete -o -name "*.jar" -delete -o -type d -empty -delete
    '';
  
  meta = with stdenv.lib; {
    description = "SQL/RDF database used by, e.g., KDE-nepomuk";
    homepage = http://virtuoso.openlinksw.com/dataspace/dav/wiki/Main/;
    platforms = platforms.all;
    maintainers = [ maintainers.urkud ];
  };
}
