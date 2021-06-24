{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_partman";
  version = "4.4.1";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "pgpartman";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "sha256-jFG2Zna97FHZin2V3Cwy5JcdeFh09Yy/eoyHtcCorPA=";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp src/*.so      $out/lib
    cp updates/*     $out/share/postgresql/extension
    cp -r sql/*      $out/share/postgresql/extension
    cp *.control     $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "Partition management extension for PostgreSQL";
    homepage    = "https://github.com/pgpartman/pg_partman";
    maintainers = with maintainers; [ ggpeti ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
