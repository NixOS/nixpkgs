{ stdenv, fetchurl, pkgconfig, file
, bison, openssl, readline, bzip2
}:

let
  version = "11.33.11";
in stdenv.mkDerivation {

  pname = "monetdb";
  inherit version;

  src = fetchurl {
    url = "https://dev.monetdb.org/downloads/sources/archive/MonetDB-${version}.tar.bz2";
    sha256 = "1fzgf1hplwlki6l6yvrk8an9y4jj40xzl4m5x1d8vi3xr526bzc9";
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
