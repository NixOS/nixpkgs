{ stdenv, fetchurl, pkgconfig, bison, openssl }:

let
  version = "11.29.3";
in stdenv.mkDerivation rec {

  name = "monetdb-${version}";

  src = fetchurl {
    url = "https://dev.monetdb.org/downloads/sources/archive/MonetDB-${version}.tar.bz2";
    sha256 = "18l4jkkryki5az5n7gnalfdxz6ibnkg3q2z4cwh1010b313wqi8s";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ bison openssl ];

  meta = with stdenv.lib; {
    description = "An open source database system";
    homepage = https://www.monetdb.org/;
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.StillerHarpo ];
  };
}
