{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_partman";
  version = "4.7.3";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "pgpartman";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "sha256-njw7/+C3nMNRKeJ4AMCNTihTVXcouH/VY2vaFeyA5v8=";
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
    changelog   = "https://github.com/pgpartman/pg_partman/raw/v${version}/CHANGELOG.txt";
    maintainers = with maintainers; [ ggpeti ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
