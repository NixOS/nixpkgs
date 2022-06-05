{ stdenv
, lib
, perlPackages
, makeWrapper
, shortenPerlShebang
, mysqlSupport ? false
, postgresqlSupport ? false
}:

let
  sqitch = perlPackages.AppSqitch;
  modules = with perlPackages; [ ]
    ++ lib.optional mysqlSupport DBDmysql
    ++ lib.optional postgresqlSupport DBDPg;
in

stdenv.mkDerivation {
  pname = "sqitch";
  version = sqitch.version;

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenv.isDarwin shortenPerlShebang;

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
  '' + lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/sqitch
  '';
  dontStrip = true;
  postFixup = ''
    wrapProgram $out/bin/sqitch --prefix PERL5LIB : ${lib.escapeShellArg (perlPackages.makeFullPerlPath modules)}
  '';

  meta = {
    inherit (sqitch.meta) description homepage license platforms;
  };
}
