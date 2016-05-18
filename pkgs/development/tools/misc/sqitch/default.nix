{ name, stdenv, perl, makeWrapper, sqitchModule, databaseModule }:

stdenv.mkDerivation {
  name = "${name}-${sqitchModule.version}";

  buildInputs = [ perl makeWrapper sqitchModule databaseModule ];

  src = sqitchModule;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    for d in bin/sqitch etc lib share ; do
      ln -s ${sqitchModule}/$d $out/$d
    done
  '';
  dontStrip = true;
  postFixup = "wrapProgram $out/bin/sqitch --prefix PERL5LIB : $PERL5LIB";
}
