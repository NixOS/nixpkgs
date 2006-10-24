{stdenv, fetchurl, coreutils}:

stdenv.mkDerivation {
  name = "findutils-4.2.28";
  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/findutils/findutils-4.2.28.tar.gz;
    md5 = "f5fb3349354ee3d94fceb81dab5c71fd";
  };
  buildInputs = [coreutils];
  patches = [./findutils-path.patch]
    # Note: the dietlibc patch is just to get findutils to compile.
    # The locate command probably won't work though.
    ++ (if stdenv ? isDietLibC then [./dietlibc-hack.patch] else []);
}
