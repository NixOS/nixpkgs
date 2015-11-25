{ stdenv, fetchurl, libX11, xproto, libXpm, libXt }:

stdenv.mkDerivation rec {
  name = "xsokoban-${version}";
  version = "3.3c";

  src = fetchurl {
    url = "http://www.cs.cornell.edu/andru/release/${name}.tar.gz";
    sha256 = "006lp8y22b9pi81x1a9ldfgkl1fbmkdzfw0lqw5y9svmisbafbr9";
  };

  buildInputs = [ libX11 xproto libXpm libXt ];

  preConfigure = ''
    sed -e 's/getline/my_getline/' -i score.c
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${libXpm.dev}/include/X11"
    for i in  $NIX_CFLAGS_COMPILE; do echo $i; ls ''${i#-I}; done
    chmod a+rw config.h
    cat >>config.h <<EOF
    #define HERE "@nixos-packaged"
    #define WWW 0
    #define OWNER "'$(whoami)'"
    #define ROOTDIR "'$out/lib/xsokoban'"
    #define ANYLEVEL 1
    #define SCOREFILE ".xsokoban-score"
    #define LOCKFILE ".xsokoban-score-lock"
    EOF

    sed -i main.c \
      -e 's/getpass[(][^)]*[)]/PASSWORD/' \
      -e '/if [(]owner[)]/iowner=1;'
  '';

  preBuild = ''
    sed -i Makefile \
      -e "s@/usr/local/@$out/@" \
      -e "s@ /bin/@ @"
    mkdir -p $out/bin $out/share $out/man/man1 $out/lib
  '';

  meta = with stdenv.lib; {
    description = "X sokoban";
    license = licenses.publicDomain;
    maintainers = [ maintainers.raskin ];
  };
}
