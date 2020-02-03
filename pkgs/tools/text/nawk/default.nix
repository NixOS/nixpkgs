{ stdenv, fetchFromGitHub, yacc }:

stdenv.mkDerivation rec {
  pname = "nawk";
  version = "20180827";

  src = fetchFromGitHub {
    owner = "onetrueawk";
    repo = "awk";
    rev = version;
    sha256 = "0qcsxhcwg6g3c0zxmbipqa8d8d5n8zxrq0hymb8yavsaz103fcl6";
  };

  nativeBuildInputs = [ yacc ];

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
    homepage = "https://www.cs.princeton.edu/~bwk/btl.mirror/";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.konimex ];
    platforms = stdenv.lib.platforms.linux;
  };
}
