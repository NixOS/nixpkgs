{ stdenv, fetchurl, pkgconfig, file
, bison, openssl, readline, bzip2
}:

let
  version = "11.35.19";
in stdenv.mkDerivation {

  pname = "monetdb";
  inherit version;

  src = fetchurl {
    url = "https://dev.monetdb.org/downloads/sources/archive/MonetDB-${version}.tar.bz2";
    sha256 = "1qfgsv1k23sn6jl7jbxmfh7w7hyzmh8r1cddl4kksqrw41q6h82q";
  };

  postPatch = ''
    sed -i "s,/usr/bin/file,${file}/bin/file," configure
  '';

  nativeBuildInputs = [ pkgconfig file ];
  buildInputs = [ bison openssl readline bzip2 ];

  meta = with stdenv.lib; {
    description = "An open source database system";
    homepage = "https://www.monetdb.org/";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.StillerHarpo ];
  };
}
