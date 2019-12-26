{ stdenv, fetchurl, pkgconfig, file
, bison, openssl, readline, bzip2
}:

let
  version = "11.35.3";
in stdenv.mkDerivation {

  pname = "monetdb";
  inherit version;

  src = fetchurl {
    url = "https://dev.monetdb.org/downloads/sources/archive/MonetDB-${version}.tar.bz2";
    sha256 = "185v8ph8jq8im77dmm20d64nwgjzzc01kz71rh09nb6x6rgcna2x";
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
