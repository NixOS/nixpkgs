args: with args;

let
  idea = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/idea.c.gz;
    md5 = "9dc3bc086824a8c7a331f35e09a3e57f";
  } else null;
in

stdenv.mkDerivation rec {
  name = "gnupg-" + version;
  src = fetchurl {
    url = "ftp://ftp.cert.dfn.de/pub/tools/crypt/gcrypt/gnupg/${name}.tar.bz2";
    sha256 = "0v009vqpa4l9zwhcaaagz5sx65fjp8g0alsf8kac5s5gvrs2b78i";
  };
  buildInputs = [readline];
  preConfigure = if ideaSupport then "gunzip < ${idea} > ./cipher/idea.c" else "";

  meta = {
    description = "A free implementation of the OpenPGP standard for encrypting and signing data";
    homepage = http://www.gnupg.org/;
  };
}
