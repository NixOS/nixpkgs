{stdenv, fetchurl, coreutils}:

stdenv.mkDerivation {
  name = "findutils-4.2.29";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/findutils/findutils-4.2.29.tar.gz;
    md5 = "24e76434ca74ba3c2c6ad621eb64e1ff";
  };
  buildInputs = [coreutils];
  patches = [./findutils-path.patch]
    # Note: the dietlibc patch is just to get findutils to compile.
    # The locate command probably won't work though.
    ++ (if stdenv ? isDietLibC then [./dietlibc-hack.patch] else []);
}
