{stdenv, fetchurl, coreutils}:

stdenv.mkDerivation {
  name = "findutils-4.2.31";
  src = fetchurl {
    url = mirror://gnu/findutils/findutils-4.2.31.tar.gz;
    sha256 = "01329mrgg7pc2069hdbcl45jzrzvi94nnv1zf2hcrcx0mj7lplz0";
  };
  buildInputs = [coreutils];

  patches = [ ./findutils-path.patch ./change_echo_path.patch ]
    # Note: the dietlibc patch is just to get findutils to compile.
    # The locate command probably won't work though.
    ++ stdenv.lib.optional (stdenv ? isDietLibC) ./dietlibc-hack.patch;
}
