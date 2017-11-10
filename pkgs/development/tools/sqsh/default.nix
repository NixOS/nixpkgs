{ stdenv, fetchurl, autoreconfHook, freetds, readline }:

let
  mainVersion = "2.5";

in stdenv.mkDerivation rec {
  name = "sqsh-${version}";
  version = "${mainVersion}.16.1";

  src = fetchurl {
    url    = "mirror://sourceforge/sqsh/sqsh/sqsh-${mainVersion}/${name}.tgz";
    sha256 = "1wi0hdmhk7l8nrz4j3kaa177mmxyklmzhj7sq1gj4q6fb8v1yr6n";
  };

  preConfigure = ''
    export SYBASE=${freetds}

    substituteInPlace src/cmd_connect.c \
      --replace CS_TDS_80 CS_TDS_73
  '';

  enableParallelBuilding = true;

  buildInputs = [ freetds readline ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Command line tool for querying Sybase/MSSQL databases";
    longDescription = ''
      Sqsh (pronounced skwish) is short for SQshelL (pronounced s-q-shell),
      it is intended as a replacement for the venerable 'isql' program supplied
      by Sybase.
    '';
    homepage = https://sourceforge.net/projects/sqsh/;
    platforms = platforms.all;
  };
}
