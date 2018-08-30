{ stdenv, fetchurl, pkgconfig
, bison, openssl, readline
}:

let
  version = "11.29.7";
in stdenv.mkDerivation rec {

  name = "monetdb-${version}";

  src = fetchurl {
    url = "https://dev.monetdb.org/downloads/sources/archive/MonetDB-${version}.tar.bz2";
    sha256 = "19f9zfg94k8hr9qc7jp1iwl8av08mibzgmid0gbqplyhf6x1j0r7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ bison openssl readline ];

  meta = with stdenv.lib; {
    description = "An open source database system";
    homepage = https://www.monetdb.org/;
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.StillerHarpo ];
  };
}
