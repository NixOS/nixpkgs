{ stdenv, fetchurl, yacc }:

stdenv.mkDerivation rec {
  name = "nawk-20121220";

  src = fetchurl {
    url = "https://www.cs.princeton.edu/~bwk/btl.mirror/awk.tar.gz";
    sha256 = "10wvdn7xwc5bbp5h7l0b9fxby3bds21n8a34z54i8kjsbhb95h4d";
  };

  nativeBuildInputs = [ yacc ];

  unpackPhase = ''
    mkdir build
    cd build
    tar xvf ${src}
  '';

  patchPhase = ''
    substituteInPlace ./makefile \
    --replace "YACC = yacc -d -S" ""
  '';

  installPhase = ''
    install -Dm755 a.out "$out/bin/nawk"
    install -Dm644 awk.1 "$out/share/man/man1/nawk.1"
  '';

  meta = {
    description = "The one, true implementation of AWK";
    longDescription = ''
       This is the version of awk described in "The AWK Programming
       Language", by Al Aho, Brian Kernighan, and Peter Weinberger
       (Addison-Wesley, 1988, ISBN 0-201-07981-X).
    '';
    homepage = https://www.cs.princeton.edu/~bwk/btl.mirror/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.konimex ];
    platforms = stdenv.lib.platforms.all;
  };
}
