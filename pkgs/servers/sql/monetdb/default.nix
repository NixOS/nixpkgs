{ stdenv, fetchurl, pkgconfig, file
, bison, openssl, readline, bzip2
}:

let
  version = "11.33.3";
in stdenv.mkDerivation rec {

  name = "monetdb-${version}";

  src = fetchurl {
    url = "https://dev.monetdb.org/downloads/sources/archive/MonetDB-${version}.tar.bz2";
    sha256 = "0k0xcm3b5qq2arjfn8f1h020sjkk97qfynsimn848bnl01vscqh8";
  };

  postPatch = ''
    sed -i "s,/usr/bin/file,${file}/bin/file," configure
  '';

  nativeBuildInputs = [ pkgconfig file ];
  buildInputs = [ bison openssl readline bzip2 ];

  meta = with stdenv.lib; {
    description = "An open source database system";
    homepage = https://www.monetdb.org/;
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.StillerHarpo ];
  };
}
