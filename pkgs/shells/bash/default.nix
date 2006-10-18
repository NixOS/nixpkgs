{stdenv, fetchurl}:

stdenv.mkDerivation ({
  name = "bash-3.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/bash-3.1.tar.gz;
    md5 = "ef5304c4b22aaa5088972c792ed45d72";
  };

  meta = {
    description = "GNU Bourne-Again Shell, the de facto standard shell on Linux";
  };
}

# libcompat.a is needed on dietlibc for stpcpy().
// (if stdenv ? isDietLibC then {
  NIX_LDFLAGS = "-lcompat";
  patches = [./winsize.patch];
} else {})

)
