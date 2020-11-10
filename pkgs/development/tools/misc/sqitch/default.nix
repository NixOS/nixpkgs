{ name, stdenv, perl, makeWrapper, sqitchModule, databaseModule, shortenPerlShebang }:

stdenv.mkDerivation {
  name = "${name}-${sqitchModule.version}";

  buildInputs = [ perl makeWrapper sqitchModule databaseModule ];

  src = sqitchModule;
  dontBuild = true;

  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin shortenPerlShebang;

  installPhase = ''
    mkdir -p $out/bin
    for d in bin/sqitch etc lib share ; do
      # make sure dest alreay exists before symlink
      # this prevents installing a broken link into the path
      if [ -e ${sqitchModule}/$d ]; then
        ln -s ${sqitchModule}/$d $out/$d
      fi
    done
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/sqitch
  '';
  dontStrip = true;
  postFixup = "wrapProgram $out/bin/sqitch --prefix PERL5LIB : $PERL5LIB";

  meta = {
    platforms = stdenv.lib.platforms.unix;
    inherit (sqitchModule.meta) license;
  };
}
