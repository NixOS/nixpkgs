{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_partman";
  version = "4.3.0";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "pgpartman";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "1zkjz4hkjqzg0j7i7bjxgdcv2kfcgqwahirh06yag6hvm4qf9y9w";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp src/*.so      $out/lib
    cp updates/*     $out/share/postgresql/extension
    cp -r sql/*      $out/share/postgresql/extension
    cp *.control     $out/share/postgresql/extension
  '';

  meta = with stdenv.lib; {
    description = "Partition management extension for PostgreSQL";
    homepage    = https://github.com/pgpartman/pg_partman;
    maintainers = with maintainers; [ ggpeti ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
