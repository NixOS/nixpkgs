. $stdenv/setup

installPhase() {
   make install
   cd $out/bin; ln -s flex lex
   cd $out/lib; ln -s libfl.a libl.a
}

installPhase=installPhase
genericBuild
