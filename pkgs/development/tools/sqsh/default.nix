{ stdenv, fetchurl, freetds, readline }:

stdenv.mkDerivation rec {
  version = "2.5.16.1";
  name = "sqsh-${version}";

  src = fetchurl {
    url = "http://www.mirrorservice.org/sites/downloads.sourceforge.net/s/sq/sqsh/sqsh/sqsh-2.5/${name}.tgz";
    sha256 = "1wi0hdmhk7l8nrz4j3kaa177mmxyklmzhj7sq1gj4q6fb8v1yr6n";
  };

  preConfigure =
    ''
    export SYBASE=${freetds}
    '';

  buildInputs = [
    freetds
    readline
  ];

  meta = {
    description = "Command line tool for querying Sybase/MSSQL databases";
    longDescription = 
      ''
      Sqsh (pronounced skwish) is short for SQshelL (pronounced s-q-shell),
      it is intended as a replacement for the venerable 'isql' program supplied
      by Sybase.
      '';
    homepage = http://www.cs.washington.edu/~rose/sqsh/sqsh.html;
    platforms = stdenv.lib.platforms.all;
  };
}
