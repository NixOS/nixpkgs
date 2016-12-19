{ stdenv, fetchurl }:

let

  srcs = {
    lemon = fetchurl {
      sha256 = "1c5pk2hz7j9hix5mpc38rwnm8dnlr2jqswf4lan6v78ccbyqzkjx";
      url = "http://www.sqlite.org/src/raw/tool/lemon.c?name=680980c7935bfa1edec20c804c9e5ba4b1dd96f5";
      name = "lemon.c";
    };
    lempar = fetchurl {
      sha256 = "1ba13a6yh9j2cs1aw2fh4dxqvgf399gxq1gpp4sh8q0f2w6qiw3i";
      url = "http://www.sqlite.org/src/raw/tool/lempar.c?name=01ca97f87610d1dac6d8cd96ab109ab1130e76dc";
      name = "lempar.c";
    };
  };

in stdenv.mkDerivation rec {
  name = "lemon-${version}";
  version = "1.69";

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    sh -xc "$CC ${srcs.lemon} -o lemon"
  '';

  installPhase = ''
    install -Dvm755 lemon $out/bin/lemon
    install -Dvm644 ${srcs.lempar} $out/bin/lempar.c
  '';

  meta = with stdenv.lib; {
    description = "An LALR(1) parser generator";
    longDescription = ''
      The Lemon program is an LALR(1) parser generator that takes a
      context-free grammar and converts it into a subroutine that will parse a
      file using that grammar. Lemon is similar to the much more famous
      programs "yacc" and "bison", but is not compatible with either.
    '';
    homepage = http://www.hwaci.com/sw/lemon/;
    license = licenses.publicDomain;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nckx ];
  };
}
