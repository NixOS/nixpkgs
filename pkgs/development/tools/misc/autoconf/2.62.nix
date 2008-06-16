{stdenv, fetchurl, m4, perl, lzma}:

stdenv.mkDerivation {
  name = "autoconf-2.61";
  src = fetchurl {
    url = ftp://ftp.gnu.org/pub/gnu/autoconf/autoconf-2.62.tar.lzma;
    sha256 = "0wc70i36cjw5kszvp50d02w8fzh2yxnsa9la6chrf7csb0dnn4jn";
  };
  buildInputs = [m4 perl lzma];
  unpackCmd="lzma -d < $src | tar -x ";
}
