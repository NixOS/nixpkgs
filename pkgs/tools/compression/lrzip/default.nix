{stdenv, fetchurl, zlib, lzo, bzip2, nasm}:

stdenv.mkDerivation rec {
  name = "lrzip-0.44";

  src = fetchurl {
    url = "http://ck.kolivas.org/apps/lrzip/${name}.tar.bz2";
    sha256 = "1ncr6igs8v6yxp60sgb9h4ra8wb7jzbxiyj4a9m4nrxyw8fwm2iv";
  };

  NIX_CFLAGS_COMPILE = "-isystem ${zlib}/include";

  buildInputs = [ zlib lzo bzip2 nasm ];

  meta = {
    homepage = http://ck.kolivas.org/apps/lrzip/;
    description = "The CK LRZIP compression program (LZMA + RZIP)";
    license = "GPLv2+";
  };
}
