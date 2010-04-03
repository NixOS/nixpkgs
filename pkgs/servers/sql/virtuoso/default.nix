a:
let
  inherit (a) stdenv fetchurl libxml2 openssl readline;
in

stdenv.mkDerivation rec {
  name = "virtuoso-opensource-6.1.0";

  src = fetchurl {
    url = "mirror://sf/virtuoso/${name}.tar.gz";
    sha256 = "1kwsb4j7k1a4mnbpjzn4hpg3bwx0bjndan5x8ffpagk5ardqi5b4";
  };

  buildInputs = [ libxml2 openssl readline ];

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
}
