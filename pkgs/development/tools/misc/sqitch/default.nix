{
  stdenv,
  lib,
  perlPackages,
  makeWrapper,
<<<<<<< HEAD
=======
  shortenPerlShebang,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  mysqlSupport ? false,
  postgresqlSupport ? false,
  sqliteSupport ? false,
  templateToolkitSupport ? false,
}:

let
  sqitch = perlPackages.AppSqitch;
  modules =
    with perlPackages;
    [ AlgorithmBackoff ]
    ++ lib.optional mysqlSupport DBDmysql
    ++ lib.optional postgresqlSupport DBDPg
    ++ lib.optional sqliteSupport DBDSQLite
    ++ lib.optional templateToolkitSupport TemplateToolkit;
in

stdenv.mkDerivation {
  pname = "sqitch";
  version = sqitch.version;

<<<<<<< HEAD
  nativeBuildInputs = [ makeWrapper ];
=======
  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenv.hostPlatform.isDarwin shortenPerlShebang;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = sqitch;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    for d in bin/sqitch etc lib share ; do
      # make sure dest alreay exists before symlink
      # this prevents installing a broken link into the path
      if [ -e ${sqitch}/$d ]; then
        ln -s ${sqitch}/$d $out/$d
      fi
    done
<<<<<<< HEAD
=======
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    shortenPerlShebang $out/bin/sqitch
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';
  dontStrip = true;
  postFixup = ''
    wrapProgram $out/bin/sqitch --prefix PERL5LIB : ${lib.escapeShellArg (perlPackages.makeFullPerlPath modules)}
  '';

  meta = {
    inherit (sqitch.meta)
      description
      homepage
      license
      platforms
      ;
    mainProgram = "sqitch";
  };
}
