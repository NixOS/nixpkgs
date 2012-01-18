a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "3.3c" a; 
  buildInputs = with a; [
    a.libX11 a.xproto a.libXpm a.libXt
  ];
in
rec {
  src = fetchurl {
    url = "http://www.cs.cornell.edu/andru/release/xsokoban-${version}.tar.gz";
    sha256 = "006lp8y22b9pi81x1a9ldfgkl1fbmkdzfw0lqw5y9svmisbafbr9";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["preConfigure" "doConfigure" "preBuild" "doMakeInstall"];

  preConfigure = a.fullDepEntry (''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${a.libXpm}/include/X11"
    for i in  $NIX_CFLAGS_COMPILE; do echo $i; ls ''${i#-I}; done
    chmod a+rw config.h
    echo '#define HERE "@nixos-packaged"' >> config.h
    echo '#define WWW 0' >> config.h
    echo '#define OWNER "'$(whoami)'"' >> config.h
    echo '#define ROOTDIR "'$out/lib/xsokoban'"' >> config.h
    echo '#define ANYLEVEL 1' >> config.h
    echo '#define SCOREFILE "/tmp/.xsokoban-score"' >> config.h
    echo '#define LOCKFILE "/tmp/.xsokoban-score-lock"' >> config.h

    sed -e 's/getpass[(][^)]*[)]/PASSWORD/' -i main.c
    sed -e '/if [(]owner[)]/iowner=1;' -i main.c
  '') ["minInit" "doUnpack"];
      
  preBuild = a.fullDepEntry (''
    sed -e "s@/usr/local/@$out/@" -i Makefile
    sed -e "s@ /bin/@ @" -i Makefile 
    mkdir -p $out/bin $out/share $out/man/man1 $out/lib
  '') ["minInit" "doConfigure" "defEnsureDir"];

  name = "xsokoban-" + version;
  meta = {
    description = "X sokoban";
  };
}
