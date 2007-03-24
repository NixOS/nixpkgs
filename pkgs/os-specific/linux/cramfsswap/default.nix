{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "cramfsswap-1.3.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.debian.org/debian/pool/main/c/cramfsswap/cramfsswap_1.3.1.tar.gz;
    sha256 = "1dh1z50spxgi0nn33ag7zzm2svl8h1w32kfhy1lzc2vxvxdfyq9r";
  };

  buildInputs = [zlib];
}
