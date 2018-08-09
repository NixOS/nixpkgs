{ stdenv, fetchurl, libxml2, openssl, readline, gawk }:

stdenv.mkDerivation rec {
  name = "virtuoso-opensource-7.2.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/virtuoso/${name}.tar.gz";
    sha256 = "12dqam1gc1v93l0bj0vlpvjqppki6y1hqrlznywxnw0rrz9pb002";
  };

  buildInputs = [ libxml2 openssl readline gawk ];

  CPP = "${stdenv.cc}/bin/gcc -E";

  configureFlags = [
    "--enable-shared" "--disable-all-vads" "--with-readline=${readline.dev}"
    "--disable-hslookup" "--disable-wbxml2" "--without-iodbc"
    "--enable-openssl=${openssl.dev}"
  ];

  postInstall=''
    echo Moving documentation
    mkdir -pv $out/share/doc
    mv -v $out/share/virtuoso/doc $out/share/doc/${name}
    echo Removing jars and empty directories
    find $out -name "*.a" -delete -o -name "*.jar" -delete -o -type d -empty -delete
    '';

  meta = with stdenv.lib; {
    description = "SQL/RDF database used by, e.g., KDE-nepomuk";
    homepage = http://virtuoso.openlinksw.com/dataspace/dav/wiki/Main/;
    #configure: The current version [...] can only be built on 64bit platforms
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
