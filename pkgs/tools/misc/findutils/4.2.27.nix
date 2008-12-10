{stdenv, fetchurl, coreutils}:

stdenv.mkDerivation {
  name = "findutils-4.2.27";
  src = fetchurl {
    url = http://nixos.org/tarballs/findutils-4.2.27.tar.gz;
    md5 = "f1e0ddf09f28f8102ff3b90f3b5bc920";
  };
  buildInputs = [coreutils];
  patches = [./findutils-path.patch]
    # Note: the dietlibc is just to get findutils to compile.  The
    # locate command probably won't work though.
    ++ (if stdenv ? isDietLibC then [./dietlibc-hack.patch] else []);
}
