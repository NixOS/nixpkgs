{ stdenv, fetchurl }:

let

  srcs = {
    lemon = fetchurl {
      sha256 = "1grm95m2cnc61zim332g7z8nchmcy91ljf50k13lm421v0ygyyv6";
      url = "http://www.sqlite.org/src/raw/tool/lemon.c?name=039f813b520b9395740c52f9cbf36c90b5d8df03";
      name = "lemon.c";
    };
    lempar = fetchurl {
      sha256 = "09nki0cwc5zrm365g6plhjxz3byhl9w117ab3yvrpds43ks1j85z";
      url = "http://www.sqlite.org/src/raw/tool/lempar.c?name=3617143ddb9b176c3605defe6a9c798793280120";
      name = "lempar.c";
    };
  };

in stdenv.mkDerivation rec {
  name = "lemon-${version}";
  version = "1.0";

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
